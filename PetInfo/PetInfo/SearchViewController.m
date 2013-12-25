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
    _searchHistoryData = [[[NSArray alloc]initWithContentsOfFile:[[FileUrl getDocumentsFile] stringByAppendingPathComponent:kSearchHistory_file_name]]retain];
    _searchData = [[NSMutableArray arrayWithArray: [[NSArray alloc]initWithContentsOfFile:[[FileUrl getDocumentsFile] stringByAppendingPathComponent:kSearchHistory_file_name]]] retain];
    
    //设置背景色
    UIImageView *searchImageVIew = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navigationbar_background.png"]];
    searchImageVIew.frame = CGRectMake(0, 0, 320, 40);
    [self.view addSubview:searchImageVIew];
    [searchImageVIew release];
    
    //设置textfield
    _searchBar = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, 290, 30)];
    _searchBar.borderStyle = UITextBorderStyleRoundedRect;
    _searchBar.delegate = self;
    [_searchBar becomeFirstResponder];
    //    _textField.clearsOnBeginEditing = YES;
    _searchBar.returnKeyType = UIReturnKeyDone;
    [_searchBar addTarget:self action:@selector(filter:) forControlEvents:UIControlEventEditingChanged];
    [searchImageVIew addSubview:_searchBar];
    
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame=CGRectMake(0, 40, ScreenWidth, _searchData.count *44 +54);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //清空按钮
    UIButton *clearButton = [[UIButton alloc]init];
    clearButton.frame = CGRectMake(0, 5, ScreenWidth, 44);
    [clearButton setTitle:@"清除历史记录" forState: UIControlStateNormal];
    [clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
    clearButton.backgroundColor = CLEARCOLOR;
    _tableView.tableFooterView = clearButton;
    [self.view addSubview:_tableView];

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
    _tableView.tableFooterView = nil;
    _tableView.bottom = 0;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_searchData count];
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
    label.text = self.searchData[indexPath.row];
    
    return cell;
}


#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    [_searchHistoryData addObject:textField.text];
    return YES;
}

- (void)filter:(UITextField *)textField
{
    if ([textField.text length] == 0) {
        _searchData = _searchHistoryData;
        [self.tableView reloadData];// insert delete
        return;
    }
    NSString *regex = [NSString stringWithFormat:@"SELF LIKE[c]'*%@*'", textField.text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:regex];
    self.searchData = [_searchHistoryData filteredArrayUsingPredicate:predicate] ;
    [self.tableView reloadData];
}
@end
