//
//  CollectionViewController.m
//  东北新闻网
//
//  Created by 佐筱猪 on 14-1-5.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "CollectionViewController.h"
#import "NightModelContentViewController.h"
#import "FMDB/src/FMDatabase.h"
#import "FileUrl.h"
@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的收藏";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NewsNightModelTableView *table = [[NewsNightModelTableView alloc]init];
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    FMDatabase *db = [FileUrl getDB];
    FMResultSet *rs =[db executeQuery:@"SELECT rowid, * FROM collectionList;"];
    while ([rs next]){
//        NSLog(@“%@ %@”,[rs stringForColumn:@"Name"],[rs stringForColumn:@"Age"]);
        [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[rs stringForColumn:@"titleId"], nil]];
    }
    
    
//    table.data = 
    table.eventDelegate = self;
    table.frame = CGRectMake(0, 0, ScreenWidth , ScreenHeight );
    [self.view addSubview:table];
}

//下拉加载
-(void)pullUp:(NewsNightModelTableView *)tableView{
    
    
}
-(void)tableView:(NewsNightModelTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NightModelContentViewController *nightModel = [[NightModelContentViewController alloc]init];
    ColumnModel *model =tableView.data[indexPath.row];
    nightModel.type = [model.type intValue];
    nightModel.titleID = [NSString stringWithFormat:@"%@",model.newsId];
    [self.navigationController pushViewController:nightModel animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
