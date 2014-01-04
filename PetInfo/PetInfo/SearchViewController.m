//
//  SearchViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "SearchViewController.h"
#import "FileUrl.h"
#import "DataCenter.h"
@interface SearchViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //读取搜索历史文件
    _searchHistoryData = [[[NSMutableArray alloc]initWithContentsOfFile:[[FileUrl getDocumentsFile] stringByAppendingPathComponent:kSearchHistory_file_name]]retain];
    _searchData = [[NSMutableArray arrayWithArray: [[NSArray alloc]initWithContentsOfFile:[[FileUrl getDocumentsFile] stringByAppendingPathComponent:kSearchHistory_file_name]]] retain];
    
//    //设置背景色
    UIImageView *searchImageVIew = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navigationbar_background.png"]];
    searchImageVIew.frame = CGRectMake(0, 0, 320, 40);
    [self.view addSubview:searchImageVIew];
    [searchImageVIew release];
    
    //设置textfield
    _searchBar = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, 290, 30)];
    _searchBar.borderStyle = UITextBorderStyleRoundedRect;
    _searchBar.delegate = self;
    [_searchBar becomeFirstResponder];
    _searchBar.clearsOnBeginEditing = YES;
    _searchBar.returnKeyType = UIReturnKeyDone;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [_searchBar addTarget:self action:@selector(filter:) forControlEvents:UIControlEventEditingChanged];
    _searchBar.leftViewMode = UITextFieldViewModeAlways;
    _searchBar.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_textfield_background.png"]];
    _searchBar.disabledBackground =[UIImage imageNamed:@"navigationbar_background.png"];

    [self.view addSubview:_searchBar];
    
    
    _tableView = [[UITableView alloc]init];
    _tableView.tag = 1304;
    int tableheigh = 200;
//    _searchData.count *44 + (_searchData.count==0?0:50);
    _tableView.frame=CGRectMake(0, 40, ScreenWidth, tableheigh);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //清空按钮
    UIButton *clearButton = [[UIButton alloc]init];
    clearButton.frame = CGRectMake(0, 5, ScreenWidth, 44);
    [clearButton setTitle:@"清除历史记录" forState: UIControlStateNormal];
    [clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
    clearButton.backgroundColor = CLEARCOLOR;
    _tableView.tableFooterView = clearButton;
    
    _resultTableView = [[UITableView alloc]init];

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
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (tableView.tag == 1304) {
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 44)];
            label.tag = 101;
            [cell.contentView addSubview:label];
        }
        
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:101];
        label.text = _searchData[indexPath.row];
    }else{
#warning
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1304) {
        //显示navigation和statebar
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self setStateBarHidden:NO];
        //textfield失去响应
        [_searchBar resignFirstResponder];
//        _searchBar.text = nil;
        NSString *text = _searchData[indexPath.row];
        //    访问数据
        DataService *service = [[DataService alloc]init];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setValue:text forKey:@"content"];
        service.eventDelegate = self ;
        [service requestWithURL:URL_Search andparams:params isJoint:YES andhttpMethod:@"POST"];
        [self showHUD:INFO_Searching isDim:YES];
        //    隐藏查询表
        [self.tableView setHidden:YES];
    }
}
#pragma mark asirequestDelegate

-(void)requestFailed:(ASIHTTPRequest *)request{
#warning
}
-(void)requestFinished:(id)result{
    [self hideHUD];
#warning 
}

#pragma mark - UITextField Delegate
//点击done按钮事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //显示navigation和statebar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setStateBarHidden:NO];
    //textfield失去响应
    [textField resignFirstResponder];
//    未输入则不查询，也不添加到查询记录中
    if (textField.text ==nil||[textField.text isEqualToString:@""]) {
        return YES;
    }
//    如果搜索历史中存在 也不存入到查询记录中
    if ([_searchHistoryData indexOfObject:textField.text] ==NSNotFound) {
        //添加到查询记录中
        [_searchHistoryData addObject:textField.text];
    }

//    隐藏查询表
    [self.tableView setHidden:YES];
    
//    访问数据
    DataService *service = [[DataService alloc]init];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:textField.text forKey:@"content"];
    service.eventDelegate = self ;
    [service requestWithURL:URL_Search andparams:params isJoint:YES andhttpMethod:@"POST"];
    [self showHUD:INFO_Searching isDim:YES];
    return YES;
}
//点击textfield事件
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text = nil;
    //    隐藏navigation和statebar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setStateBarHidden:YES];
//    刷新数据
    self.searchData = _searchHistoryData;
    [self.tableView reloadData];
    [self.tableView setHidden:NO];
//    如果数据大于0 则显示foot按钮
    if (_searchHistoryData.count >0) {
        [_tableView.tableFooterView setHidden:NO ];
    }else{
        [_tableView.tableFooterView setHidden:YES ];

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
    if (_searchData.count==0&&_searchHistoryData.count>0) {
        [_tableView.tableFooterView setHidden:YES ];

    }
}
@end
