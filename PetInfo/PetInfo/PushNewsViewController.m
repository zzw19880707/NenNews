//
//  PushNewsViewController.m
//  东北新闻网
//
//  Created by 佐筱猪 on 14-1-5.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "PushNewsViewController.h"
#import "NightModelContentViewController.h"
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
    NewsNightModelTableView *table = [[NewsNightModelTableView alloc]init];
    table.eventDelegate = self;
    table.frame = CGRectMake(0, 0, ScreenWidth , ScreenHeight - 44-20);
    [self.view addSubview:table];
    [table autoRefreshData];
    
}
#pragma mark UItableviewEventDelegate
//上拉刷新
-(void)pullDown:(NewsNightModelTableView *)tableView{
    
    //    参数
    NSMutableDictionary *params  = [[NSMutableDictionary alloc]init];
    int count = [[NSUserDefaults standardUserDefaults]integerForKey:kpageCount];
    NSNumber *number = [NSNumber numberWithInt:(count*10)];
    [params setValue:number forKey:@"count"];
    if (tableView.data.count>0) {
        ColumnModel *model = tableView.data[0];
        int sinceID = [model.titleId intValue];
        [params setValue:[NSNumber numberWithInt:sinceID] forKey:@"maxId"];
    }
    //    [params setValue:<#(id)#> forKey:@"maxId"];
    
    [DataService requestWithURL:URL_getPush_List andparams:params andhttpMethod:@"POST" completeBlock:^(id result) {
        NSArray *array =  [result objectForKey:@"data"];
        NSMutableArray *listData = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic  in array) {
            ColumnModel * model = [[ColumnModel alloc]initWithDataDic:dic];
            [listData addObject:model];
        }
        tableView.data =listData;

        [tableView reloadData];
        [tableView doneLoadingTableViewData];
        
    } andErrorBlock:^(NSError *error) {
        [tableView doneLoadingTableViewData];
        
    }];
}
//下拉加载
-(void)pullUp:(NewsNightModelTableView *)tableView{
    
    //    参数
    NSMutableDictionary *params  = [[NSMutableDictionary alloc]init];
    int count = [[NSUserDefaults standardUserDefaults]integerForKey:kpageCount];
    NSNumber *number = [NSNumber numberWithInt:(count*10)];
    [params setValue:number forKey:@"count"];
    if (tableView.data.count>0) {
        ColumnModel *model = tableView.data[tableView.data.count];
        int sinceID = [model.titleId intValue];
        [params setValue:[NSNumber numberWithInt:sinceID] forKey:@"sinceId"];
    }
    [DataService requestWithURL:URL_getPush_List andparams:params andhttpMethod:@"POST" completeBlock:^(id result) {
        NSArray *array =  [result objectForKey:@"data"];
        NSMutableArray *listData = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic  in array) {
            ColumnModel * model = [[ColumnModel alloc]initWithDataDic:dic];
            [listData addObject:model];
        }
        [tableView doneLoadingTableViewData];
        [listData addObjectsFromArray:tableView.data];
        
        tableView.data  = listData;
        [tableView reloadData];
    } andErrorBlock:^(NSError *error) {
        [tableView doneLoadingTableViewData];
    }];
    
}
-(void)tableView:(NewsNightModelTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        NightModelContentViewController *nightModel = [[NightModelContentViewController alloc]init];
        ColumnModel *model =tableView.data[indexPath.row];
        nightModel.type = model.type;
        nightModel.titleID = [NSString stringWithFormat:@"%@",model.titleId];
        [self.navigationController pushViewController:nightModel animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
