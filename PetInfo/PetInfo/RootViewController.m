//
//  RootViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-19.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "RootViewController.h"
#import "Uifactory.h"
#import "FileUrl.h"
#import "WebViewController.h"
#import "NightModelContentViewController.h"
#import "ThemeManager.h"
@interface RootViewController (){
    BOOL _enable;
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"东北新闻网";
    }
    return self;
}
//初始化按钮
-(NSArray *)_initButton {
    
    //读取全部显示菜单
    
    NSString *pathName = [[FileUrl getDocumentsFile] stringByAppendingPathComponent:column_show_file_name];
    //栏目数组
    NSMutableArray *nameArrays = [[NSMutableArray alloc]initWithContentsOfFile:pathName];
    //    用于存放按钮
    NSMutableArray *buttonArrays = [[NSMutableArray alloc]init];
    
    //    用于存放tableview
    NSMutableArray *tableArrays = [[NSMutableArray alloc]init];
    for (int i =0; i<nameArrays.count; i++) {
        int columnId = [[nameArrays[i] objectForKey:@"columnId"] intValue];
        UIButton *button = [Uifactory createButton:[nameArrays[i] objectForKey:@"name"]];
        button.frame = CGRectMake(10 + 70*i, 0, 60, 30);
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.tag = 1000+ i;
        [buttonArrays addObject:button];
        
        
        NewsNightModelTableView *newsTableView = [[NewsNightModelTableView alloc]initwithColumnID:columnId];
        newsTableView.frame = CGRectMake(340 *i, 0, ScreenWidth, ScreenHeight -44-20);
        newsTableView.eventDelegate = self;
        newsTableView.changeDelegate = self;
        newsTableView.type = 0;
        NSMutableDictionary *d = [[NSMutableDictionary alloc]initWithContentsOfFile:[[FileUrl getDocumentsFile]stringByAppendingPathComponent:data_file_name]];
        
        NSMutableDictionary *dic = [d objectForKey:[NSString stringWithFormat:@"%d",columnId]];
        if (dic.count>0) {
            NSMutableArray *data = [[NSMutableArray alloc]init];
            NSArray *array=[dic objectForKey:@"data"];
            for (NSDictionary *dictionary in array) {
                ColumnModel *model = [[ColumnModel alloc]initWithDataDic:dictionary];
                [data addObject:model];
            }
            newsTableView.data = data;
            [data release];
            newsTableView.imageData = [dic objectForKey:@"picture"];
        }else{
            newsTableView.data = [[NSArray alloc]init];
            newsTableView.imageData = [[NSArray alloc]init];
        }
        [tableArrays addObject:newsTableView];
        
    }
    //    用于存放按钮和tableview
    NSArray *arrays = @[buttonArrays,tableArrays];
    return arrays;
}

-(void)_initNavagationbarButton {
    //添加状态栏按钮
    UIButton *leftButton = [[UIButton alloc]init];
    leftButton.backgroundColor=CLEARCOLOR;
    leftButton.frame=CGRectMake(0, 0, 35, 35);
    [leftButton setImage:[UIImage imageNamed:@"left_item_button.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setShowsTouchWhenHighlighted:YES];
    
    UIButton *rightButton = [[UIButton alloc]init];
    rightButton.backgroundColor=CLEARCOLOR;
    rightButton.frame=CGRectMake(0, 0, 35, 35);
    [rightButton setImage:[UIImage imageNamed:@"right_item_button.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem= [leftitem autorelease];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= [rightItem autorelease];
    
    
}
#pragma mark UIScrollViewEventDelegate
-(void)addButtonAction{
    ColumnTabelViewController *columnVC = [[ColumnTabelViewController alloc]init];
    columnVC.eventDelegate = self;
    _po(self.navigationController);
    [self.navigationController pushViewController:columnVC animated:YES];
}
-(void)showRightMenu{
    [self.appDelegate.menuCtrl showRightController:YES];
    
}
-(void)showLeftMenu{
    [self.appDelegate.menuCtrl showLeftController:YES];
    
}
-(void)setEnableGesture:(BOOL)b{
    _enable = b;
    [self.appDelegate.menuCtrl setEnableGesture:b];
}
-(void)autoRefreshData:(NewsNightModelTableView *)tableView{
    [self getData:tableView];
}
#pragma mark
#pragma mark UI
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self _initNavagationbarButton];
    
    _sc = [[BaseScrollView alloc]initwithButtons:[self _initButton] WithFrame:CGRectMake(0, 0, 320, ScreenHeight)];
    _sc.eventDelegate = self;
    [self.view addSubview:_sc];
    
    
    NewsNightModelTableView *table  = (NewsNightModelTableView *) VIEWWITHTAG( VIEWWITHTAG(_sc, 10001), 1300);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyMMddHHmm"];
    _po([formatter stringFromDate:[NSDate date]]);
    int data =[[formatter stringFromDate:[NSDate date]] intValue];
    table.lastDate = data;
    [self getData:table];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //    开启左滑、右滑菜单
    [self.appDelegate.menuCtrl setEnableGesture:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //    禁用左滑、右滑菜单
    [self.appDelegate.menuCtrl setEnableGesture:NO];
    
}

#pragma mark UIScrollViewEventDelegate
-(void)ImageViewDidSelected:(NSInteger)index andData:(NSArray *)imageData{
    if (index>0) {
        WebViewController *webView = [[WebViewController alloc]initWithUrl:[imageData[index] objectForKey:@"url"]];
        [self.navigationController pushViewController:webView animated:YES];
    }else{
        NightModelContentViewController *nightModel = [[NightModelContentViewController alloc]init];
        nightModel.newsId = [imageData[index] objectForKey:@"newsId"] ;
        nightModel.type = [[imageData[index] objectForKey:@"type"] intValue];
        nightModel.newsAbstract = [imageData[index] objectForKey:@"newsAbstract"] ;
        nightModel.ImageUrl =[imageData[index] objectForKey:@"img"];
        [self.navigationController pushViewController:nightModel animated:YES];
    }
}

-(ColumnModel *)addisselected :(ColumnModel *)model {
    NSString *newsId = model.newsId;
    FMResultSet *rs =[self.db executeQuery:@"select * from columnData where newsId = ?",newsId];
    while (rs.next) {
        model.isselected = YES;
        return model;
    }
    return model;
}
#pragma mark UItableviewEventDelegate
-(void)getData :(NewsNightModelTableView *)tableView{
    [self getConnectionAlert];
    
    //    参数
    NSMutableDictionary *params  = [[NSMutableDictionary alloc]init];
    int count = [[NSUserDefaults standardUserDefaults]integerForKey:kpageCount];
    NSNumber *number = [NSNumber numberWithInt:((count+1)*10)];
    [params setValue:number forKey:@"count"];
    int columnID=tableView.columnID;
    [params setValue:[NSNumber numberWithInt:columnID] forKey:@"columnID"];
    if (tableView.data.count>0) {
        ColumnModel *model = tableView.data[0];
        NSString *sinceID = model.newsId;
        [params setValue:sinceID forKey:@"maxId"];
    }
    [DataService requestWithURL:URL_getColumn_List andparams:params andhttpMethod:@"GET" completeBlock:^(id result) {
        tableView.isMore = true;
        NSArray *array =  [result objectForKey:@"data"];
        if (array.count ==0) {
            [tableView doneLoadingTableViewData];
            return ;
        }
        NSMutableArray *listData = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic  in array) {
            ColumnModel * model = [[ColumnModel alloc]initWithDataDic:dic];
            model = [self addisselected:model];
            [listData addObject:model];
        }
        
        [listData addObjectsFromArray:tableView.data];
        tableView.data =listData;
        tableView.imageData = [result objectForKey:@"picture"];
        [tableView reloadData];
        [tableView doneLoadingTableViewData];
        
    } andErrorBlock:^(NSError *error) {
        [tableView doneLoadingTableViewData];
    }];
    
}

//上拉刷新
-(void)pullDown:(NewsNightModelTableView *)tableView{
    [self getData:tableView];
    
}
//下拉加载
-(void)pullUp:(NewsNightModelTableView *)tableView{
    
    //    参数
    NSMutableDictionary *params  = [[NSMutableDictionary alloc]init];
    int count = [[NSUserDefaults standardUserDefaults]integerForKey:kpageCount];
    NSNumber *number = [NSNumber numberWithInt:((count+1)*10)];
    [params setValue:number forKey:@"count"];
    int columnID=tableView.columnID;
    [params setValue:[NSNumber numberWithInt:columnID] forKey:@"columnID"];
    if (tableView.data.count>0) {
        ColumnModel *model = [tableView.data lastObject];
        NSString *sinceID = model.newsId;
        [params setValue:sinceID forKey:@"sinceId"];
    }
    [self getConnectionAlert];
    [DataService requestWithURL:URL_getColumn_List andparams:params andhttpMethod:@"GET" completeBlock:^(id result) {
        NSArray *array =  [result objectForKey:@"data"];
        NSArray *imageArray = [result objectForKey:@"picture"];
        NSMutableArray *listData = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic  in array) {
            ColumnModel * model = [[ColumnModel alloc]initWithDataDic:dic];
            model = [self addisselected:model];
            [listData addObject:model];
        }
        
        [tableView doneLoadingTableViewData];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:tableView.data];
        [arr addObjectsFromArray:listData];
        tableView.data  = arr;
        if (imageArray.count !=0) {
            tableView.imageData = imageArray;
        }
        if (listData.count < count*10) {
            tableView.isMore = false;
        }
        [tableView reloadData];
        
    } andErrorBlock:^(NSError *error) {
        [tableView doneLoadingTableViewData];
        
    }];
    
    
    
}
-(void)tableView:(NewsNightModelTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.imageData.count >0&&indexPath.section==0) {
        
    }else{
        ColumnModel *model =tableView.data[indexPath.row];
        [self pushNewswithColumn:model];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark 按钮事件
- (void)leftAction {
    [self.appDelegate.menuCtrl showLeftController:YES];
}
- (void)rightAction {
    [self.appDelegate.menuCtrl showRightController:YES];
    
}


#pragma mark columnchangeDelegate
-(void)columnChanged:(NSArray *)array{
    _sc.buttonsNameArray = [self _initButton];
    NewsNightModelTableView *table  = (NewsNightModelTableView *) VIEWWITHTAG( VIEWWITHTAG(_sc, 10001), 1300);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyMMddHHmm"];
    _po([formatter stringFromDate:[NSDate date]]);
    int data =[[formatter stringFromDate:[NSDate date]] intValue];
    table.lastDate = data;
    [self getData:table];
}
#pragma mark 内存管理
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    RELEASE_SAFELY(_sc);
    [super dealloc];
}

@end
