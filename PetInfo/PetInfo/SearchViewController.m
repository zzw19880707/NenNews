//
//  SearchViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "SearchViewController.h"
#import "FileUrl.h"
#import "NightModelContentViewController.h"
#import "DataCenter.h"
#import "ColumnModel.h"
@interface SearchViewController (){
    UIView *_searchBGView;
}
@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"搜索";
    }
    return self;
}

-(void)_initSearchBar{
    //读取搜索历史文件
    _searchHistoryData = [[[NSMutableArray alloc]initWithContentsOfFile:[[FileUrl getDocumentsFile] stringByAppendingPathComponent:kSearchHistory_file_name]]retain];
    _searchData = [[NSMutableArray arrayWithArray: [[NSArray alloc]initWithContentsOfFile:[[FileUrl getDocumentsFile] stringByAppendingPathComponent:kSearchHistory_file_name]]] retain];
    
    //设置textfield
    _searchBar = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, 290, 30)];
    _searchBar.borderStyle = UITextBorderStyleRoundedRect;
    _searchBar.placeholder = @"\t\t搜索";
    //    _searchBar.
    _searchBar.delegate = self;
    _searchBar.clearsOnBeginEditing = YES;
    _searchBar.returnKeyType = UIReturnKeyDone;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [_searchBar addTarget:self action:@selector(filter:) forControlEvents:UIControlEventEditingChanged];
    _searchBar.leftViewMode = UITextFieldViewModeAlways;
    _searchBar.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_textfield_background.png"]];
    _searchBar.disabledBackground =[UIImage imageNamed:@"navigationbar_background.png"];
    self.navigationItem.titleView = _searchBar ;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.resultTableView = [[UITableView alloc]init];
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    self.resultTableView.delaysContentTouches = NO;
    //    _resultTableView.backgroundColor = [UIColor redColor];
    _resultTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:self.resultTableView];
    
    
    _searchBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _searchBGView.backgroundColor = NenNewsTextColor;
    _searchBGView.userInteractionEnabled = YES;
    [self.view addSubview:_searchBGView];
    
    
    [self _initSearchBar];
    
    _tableView = [[UITableView alloc]init];
    _tableView.tag = 1304;
//    int tableheigh = 200;
    _tableView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.delaysContentTouches = NO;
    [self.view addSubview:_tableView];
    _tableView.height = _searchData.count *44;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disFocus:)];
    [_searchBGView addGestureRecognizer:tapGesture];

    //清空按钮
    UIButton *clearButton = [[UIButton alloc]init];
    clearButton.frame = CGRectMake(0, 5, ScreenWidth, 44);
    [clearButton setTitle:@"清除历史记录" forState: UIControlStateNormal];
    [clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
    clearButton.backgroundColor = CLEARCOLOR;
    _tableView.tableFooterView = clearButton;
//    [self.view addSubview:_searchBGView];



}


-(void)viewWillDisappear:(BOOL)animated{
    NSString *path = [[FileUrl getDocumentsFile] stringByAppendingPathComponent:kSearchHistory_file_name];
    [_searchHistoryData writeToFile:path atomically:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_searchBar release];
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSearchBar:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark Action 
-(void)clearHistory{
    _searchHistoryData = [[NSMutableArray alloc]init];
    _searchData = [[NSArray alloc]init];
    [_tableView reloadData];
    [_tableView.tableFooterView setHidden:YES ];
//    _tableView.bottom = 0;
    _tableView.height = 0;
}
-(void)disFocus:(UITapGestureRecognizer *)UIGR{

    [self bgViewhidden];

}
-(void) bgViewhidden {
    [_searchBar resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        _searchBGView.alpha = 0;
        _tableView.alpha = 0;
    } completion:^(BOOL finished) {
        [_searchBGView setHidden:YES];
        [_tableView setHidden:YES];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag ==1304) {
        return [_searchData count];

    }else{
        return [_resultData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 44)];
            label.tag = 101;
            [cell.contentView addSubview:label];
        }
        
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:101];
    if (tableView.tag == 1304) {

        label.text = _searchData[indexPath.row];
    }else{
        ColumnModel *model = _resultData[indexPath.row];
        label.text = model.title;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self getConnectionAlert]) {
        if (tableView.tag == 1304) {
            //textfield失去响应
            [_searchBar resignFirstResponder];
            NSString *text = _searchData[indexPath.row];
            //    访问数据
            DataService *service = [[DataService alloc]init];
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setValue:text forKey:@"content"];
            service.eventDelegate = self ;
            [service requestWithURL:URL_Search andparams:params isJoint:YES andhttpMethod:@"GET"];
            [self showHUD:INFO_Searching isDim:YES];
            //    隐藏查询表
            [self.tableView setHidden:YES];
            [self bgViewhidden];
        }else{
#warning
            ColumnModel *model =_resultData[indexPath.row];
            [self pushNewswithColumn:model];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];

        }

    }
}
#pragma mark asirequestDelegate

-(void)requestFailed:(ASIHTTPRequest *)request{
    [self hideHUD];
}
-(void)requestFinished:(id)result{
    [self hideHUD];
    NSMutableArray *list= [[NSMutableArray alloc]init];
    NSArray *array =[result objectForKey:@"news"];
    for (NSDictionary *dic in array) {
        ColumnModel *model = [[ColumnModel alloc]initWithDataDic:dic];
        [list addObject: model];
        [model release];
    }
    _resultData = list;
    [self.resultTableView reloadData];
}

#pragma mark - UITextField Delegate

//点击textfield事件
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text = nil;
//    刷新数据
    self.searchData = _searchHistoryData;
    [self.tableView reloadData];
//    [self.tableView setHidden:NO];
//    如果数据大于0 则显示foot按钮
    if (_searchHistoryData.count >0) {
        [_tableView.tableFooterView setHidden:NO ];
    }else{
        [_tableView.tableFooterView setHidden:YES ];
    }
    [_searchBGView setHidden:NO];
    [_tableView setHidden:NO];
    if (_searchData.count *44>ScreenHeight) {
        _tableView.height = ScreenHeight;
    }else{
        _tableView.height = _searchData.count *44 +44;
    }
    [UIView animateWithDuration:0.2 animations:^{
        _searchBGView.alpha = 1;
        _tableView.alpha =1;
    } completion:^(BOOL finished) {
        
    }];
    return YES;
}
//点击done按钮事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    未输入则不查询，也不添加到查询记录中
    if (textField.text ==nil||[textField.text isEqualToString:@""]) {
        return NO;
    }
    //    如果搜索历史中存在 也不存入到查询记录中
    if ([_searchHistoryData indexOfObject:textField.text] ==NSNotFound) {
        //添加到查询记录中
        [_searchHistoryData addObject:textField.text];
    }

    if ([self getConnectionAlert]) {
        [self bgViewhidden];
        //    访问数据
        DataService *service = [[DataService alloc]init];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setValue:textField.text forKey:@"content"];
        service.eventDelegate = self ;
        [service requestWithURL:URL_Search andparams:params isJoint:YES andhttpMethod:@"GET"];
        [self showHUD:INFO_Searching isDim:YES];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)filter:(UITextField *)textField
{
    if ([textField.text length] == 0) {
        self.searchData = _searchHistoryData;
        [self.tableView reloadData];// insert delete
        return;
    }
    NSString *regex = [NSString stringWithFormat:@"SELF LIKE[c]'*%@*'", textField.text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:regex];
    self.searchData=[_searchHistoryData filteredArrayUsingPredicate:predicate] ;
    [self.tableView reloadData];
    if (_searchData.count *44>ScreenHeight) {
    }else{
        _tableView.height = _searchData.count *44 +44;
    }
//    _tableView.height = ;
    if (_searchData.count==0) {
        _tableView.height = 0;
        [_tableView.tableFooterView setHidden:YES ];
    }else{
        [_tableView.tableFooterView setHidden:NO ];

    }
}
@end
