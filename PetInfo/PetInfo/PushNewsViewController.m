//
//  PushNewsViewController.m
//  东北新闻网
//
//  Created by 佐筱猪 on 14-1-5.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "PushNewsViewController.h"
#import "NightModelContentViewController.h"
#import "FMDatabase.h"
@interface PushNewsViewController ()

@end

@implementation PushNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"推送新闻";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NewsNightModelTableView *table = [[NewsNightModelTableView alloc]initWithData:nil type:2];
    table.refreshHeader= YES;
    table.eventDelegate = self;
    table.frame = CGRectMake(0, 0, ScreenWidth , ScreenHeight-44);
    [self.view addSubview:table];
    [table autoRefreshData];
    [self getData:table];
    
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
    
    //    参数
    NSMutableDictionary *params  = [[NSMutableDictionary alloc]init];
    int count = [[NSUserDefaults standardUserDefaults]integerForKey:kpageCount];
    NSNumber *number = [NSNumber numberWithInt:((count+1)*10)];
    [params setValue:number forKey:@"count"];
    ColumnModel *model ;
    if (tableView.data>0) {
        NSArray *today = tableView.data[0];
        NSArray *yesday = tableView.data[1];
        NSArray *more = tableView.data[2];
        
        if([today count]!=0||[yesday count]!=0||[more count]!=0){
            if (today.count >0) {
                model = today[0];
            }else if( yesday.count>0){
                model = yesday[0];
            }else{
                model = more[0];
            }
            NSString *sinceID = model.newsId;
            [params setValue:sinceID forKey:@"maxId"];
            
        }
    }
    [self getConnectionAlert];
    [DataService requestWithURL:URL_getPush_List andparams:params andhttpMethod:@"GET" completeBlock:^(id result) {
        tableView.isMore = true;
        NSArray *todayarray =  [result objectForKey:@"today"];
        NSArray *yesterdayarray =  [result objectForKey:@"yesterday"];
        NSArray *earlierarray =  [result objectForKey:@"earlier"];
        
        NSMutableArray *listData;
        if (tableView.data.count>0) {
            listData = [[NSMutableArray alloc]initWithArray:tableView.data];
        }else{
            listData= [[NSMutableArray alloc]initWithCapacity:3];
        }
        NSArray *array = @[todayarray,yesterdayarray,earlierarray];
        for (int i = 0 ; i<array.count ; i++) {
            NSMutableArray *middel = [[NSMutableArray alloc]init];
            for (NSDictionary *dic  in array[i]) {
                ColumnModel * model = [[ColumnModel alloc]initWithDataDic:dic];
                model = [self addisselected:model];
                [middel addObject:model];
                
            }
            if (tableView.data.count>0) {
                [listData[i] addObjectsFromArray:middel];
            }else{
                [listData addObject:middel];
            }
            [middel release];
        }
        tableView.data =listData;
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
    if (tableView.data.count>0) {
        ColumnModel *model ;
        if ([ tableView.data[2] count]>0) {
            model =tableView.data[2][[tableView.data[2] count]-1];
        }else if ( [ tableView.data[1] count]>0 ){
            model =tableView.data[1][[tableView.data[1] count]-1];
        }else{
            model =tableView.data[0][[tableView.data[0] count]-1];
        }
        int sinceID = [model.newsId intValue];
        [params setValue:[NSNumber numberWithInt:sinceID] forKey:@"sinceId"];
    }
    [self getConnectionAlert];
    [DataService requestWithURL:URL_getPush_List andparams:params andhttpMethod:@"GET" completeBlock:^(id result) {
        NSArray *todayarray =  [result objectForKey:@"today"];
        NSArray *yesterdayarray =  [result objectForKey:@"yesterday"];
        NSArray *earlierarray =  [result objectForKey:@"earlier"];
        NSMutableArray *listData;
        if (tableView.data.count>0) {
            listData = [[NSMutableArray alloc]initWithArray:tableView.data];
        }else{
            listData= [[NSMutableArray alloc]initWithCapacity:3];
        }
        NSMutableArray *arr =listData;

        
        NSArray *array = @[todayarray,yesterdayarray,earlierarray];
        for (int i = 0 ; i<array.count ; i++) {
            NSMutableArray *middel = [[NSMutableArray alloc]init];
            for (NSDictionary *dic  in array[i]) {
                ColumnModel * model = [[ColumnModel alloc]initWithDataDic:dic];
                model = [self addisselected:model];
                [middel addObject:model];
                
            }
            if (middel.count>0) {
                [listData[i] addObjectsFromArray:middel];
                [arr[i] addObjectsFromArray:listData];
            }
            [middel release];
        }
        tableView.data =arr;
        

        [tableView doneLoadingTableViewData];

        [tableView reloadData];
    } andErrorBlock:^(NSError *error) {
        [tableView doneLoadingTableViewData];
    }];

}
-(void)tableView:(NewsNightModelTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NightModelContentViewController *nightModel = [[NightModelContentViewController alloc]init];
    ColumnModel *model;
    if (tableView.type ==2) {
        model =tableView.data[indexPath.section][indexPath.row];
    }else{
        model =tableView.data[indexPath.row];

    }
    nightModel.type = [model.type intValue];
    nightModel.newsId = [NSString stringWithFormat:@"%@",model.newsId];
    [self.navigationController pushViewController:nightModel animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
