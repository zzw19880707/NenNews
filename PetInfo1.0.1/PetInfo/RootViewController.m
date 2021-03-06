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
#import "DataCenter.h"
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
    
    //栏目数组
    NSMutableArray *nameArrays = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:show_column]];
    //    用于存放按钮
    NSMutableArray *buttonArrays = [[NSMutableArray alloc]init];
    
    //    用于存放tableview
    NSMutableArray *tableArrays = [[NSMutableArray alloc]init];
    for (int i =0; i<nameArrays.count; i++) {
        int columnId = [[nameArrays[i] objectForKey:@"columnId"] intValue];
        UIButton *button = [Uifactory createButton:[nameArrays[i] objectForKey:@"name"]];
        button.frame = CGRectMake(10 + 70*i, 0, 60, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.tag = 1000+ i;
        [buttonArrays addObject:button];
        
        
        NewsNightModelTableView *newsTableView = [[NewsNightModelTableView alloc]initwithColumnID:columnId];
        newsTableView.frame = CGRectMake(340 *i, 0, ScreenWidth, ScreenHeight -44-20);
        newsTableView.eventDelegate = self;
        newsTableView.changeDelegate = self;
        newsTableView.type = 0;
//        设置数据
        [self getData:newsTableView cache:1];
        [tableArrays addObject:newsTableView];
        
    }
    //    用于存放按钮和tableview
    NSArray *arrays = @[buttonArrays,tableArrays];
    return arrays;
}


#pragma mark UIScrollViewEventDelegate
-(void)addButtonAction{
    ColumnTabelViewController *columnVC = [[ColumnTabelViewController alloc]initWithType:0];
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
    [self getData:tableView cache:0];
}
-(void)autoRefreshDatawithCache:(NewsNightModelTableView *)tableView{
    [self getData:tableView cache:1];
}
#pragma mark
#pragma mark UI
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _sc = [[BaseScrollView alloc]initwithButtons:[self _initButton] WithFrame:CGRectMake(0, 0, 320, ScreenHeight)];
    _sc.eventDelegate = self;
    [self.view addSubview:_sc];
    
    
    NewsNightModelTableView *table  = (NewsNightModelTableView *) VIEWWITHTAG( VIEWWITHTAG(_sc, 10001), 1300);
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyMMddHHmm"];
//    _po([formatter stringFromDate:[NSDate date]]);
//    int data =[[formatter stringFromDate:[NSDate date]] intValue];
//    table.lastDate = data;
    [self getData:table cache:1];
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
    NSString *url = [imageData[index] objectForKey:@"url"];
    if (url!=nil&&![url isEqualToString:@""]) {
        WebViewController *webView = [[WebViewController alloc]initWithUrl:url];
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
//cache 0:正常缓存 1代表只读本地
-(void)getData :(NewsNightModelTableView *)tableView cache:(int)cache{
    [self getConnectionAlert];
    //    参数
    NSMutableDictionary *params  = [[NSMutableDictionary alloc]init];
    int count = [[NSUserDefaults standardUserDefaults]integerForKey:kpageCount];
    NSNumber *number = [NSNumber numberWithInt:((count+1)*10)];
    [params setValue:number forKey:@"count"];
    int columnID=tableView.columnID;
    [params setValue:[NSNumber numberWithInt:columnID] forKey:@"columnID"];
//    if (tableView.data.count>0) {
//        ColumnModel *model = tableView.data[0];
//        NSString *sinceID = model.newsId;
//        [params setValue:sinceID forKey:@"maxId"];
//    }
    [params setValue:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"columnid=%d",tableView.columnID]] objectForKey:@"maxId"] forKey:@"maxId"];
//    正常访问网络
    if (cache ==0) {
        [DataService requestWithURL:URL_getColumn_List andparams:params andhttpMethod:@"GET" completeBlock:^(id result) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyMMddHHmm"];
            int date =[[formatter stringFromDate:[NSDate date]] intValue];
            tableView.lastDate = date;
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
            
            //        [listData addObjectsFromArray:tableView.data];
            tableView.data =listData;
            tableView.imageData = [result objectForKey:@"picture"];
            [tableView reloadData];
            if (tableView.imageData.count >0) {
                [tableView.csView reloadData];
            }
            [tableView doneLoadingTableViewData];
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            ColumnModel *model = tableView.data[0];
            NSString *sinceID = model.newsId;
            
            NSDictionary *columnDIC = @{@"maxId":sinceID,@"lastDate":[NSNumber numberWithInt:date]};
            
            [userDefault setValue:columnDIC forKey:[NSString stringWithFormat:@"columnid=%d",tableView.columnID]];
            [userDefault synchronize];
            
        } andErrorBlock:^(NSError *error) {
            [tableView doneLoadingTableViewData];
        }];
    }else{
//        只读本地
        [DataService nocacheWithURL:URL_getColumn_List andparams:params completeBlock:^(id result) {
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
            
            //        [listData addObjectsFromArray:tableView.data];
            tableView.data =listData;
            tableView.imageData = [result objectForKey:@"picture"];
            [tableView reloadData];
            if (tableView.imageData.count >0) {
                [tableView.csView reloadData];
            }
            [tableView doneLoadingTableViewData];
//            设置tableview的最后更新时间
            
            int date = [[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"columnid=%d",tableView.columnID]] objectForKey:@"lastDate"] intValue];
            if (date==0) {
                
            }else{
                tableView.lastDate =date;

            }
            
        } andErrorBlock:^(NSError *error) {
            [tableView doneLoadingTableViewData];
        }];
    }
    

    
    
    
    
    
}

//上拉刷新
-(void)pullDown:(NewsNightModelTableView *)tableView{
    if (![self getConnectionAlert]) {
        [tableView doneLoadingTableViewData];

        return;
    }
    [self getData:tableView cache:0];
    
}
//下拉加载
-(void)pullUp:(NewsNightModelTableView *)tableView{
    if (![self getConnectionAlert]) {
        [tableView doneLoadingTableViewData];

        return;
    }
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
        if (listData.count < (count+1)*10) {
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




#pragma mark columnchangeDelegate
-(void)columnChanged:(NSArray *)array{
    _sc.buttonsNameArray = [self _initButton];
//    NewsNightModelTableView *table  = (NewsNightModelTableView *) VIEWWITHTAG( VIEWWITHTAG(_sc, 10001), 1300);
//    [self getData:table cache:1];
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
