//
//  CollectionViewController.m
//  东北新闻网
//
//  Created by 佐筱猪 on 14-1-5.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "CollectionViewController.h"
#import "NightModelContentViewController.h"
#import "FMDatabase.h"
#import "FileUrl.h"
#import "ColumnModel.h"
#import "Uifactory.h"
@interface CollectionViewController ()

@end

@implementation CollectionViewController
#define collection_count @"15"
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
    self.tableView = [[NewsNightModelTableView alloc]initWithData:[self getData:@""] type:1];
    self.tableView.eventDelegate = self;
    self.tableView.frame = CGRectMake(0 , 0, ScreenWidth , ScreenHeight );
    [self.view addSubview:self.tableView];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tableView.data = [self getData:@""];
    [_tableView reloadData];
    [super viewWillAppear:animated];
}
-(NSArray *)getData:(NSString *)lastId {
    NSArray *data =[[NSArray alloc]init];
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    

    NSString *sql ;
    if (lastId.length>0) {
        sql = [NSString stringWithFormat:@"SELECT  * FROM collectionList where newsId< '%@'  order by newsId DESC limit %@ ",lastId,collection_count];
    }else{
        sql = [NSString stringWithFormat:@"SELECT  * FROM collectionList order by newsId DESC  limit %@;",collection_count];
    }
    FMResultSet *rs = [self.db executeQuery:sql];
    while ([rs next]){
        int type = [rs intForColumn:@"type"];
        NSString *newId = [rs stringForColumn:@"newsId"];
        NSString *title = [rs stringForColumn:@"title"];
        if (title.length>0) {
            
        }else{
            title = @"";
        }
        NSDictionary *dic = @{
                              @"newsId":newId,
                              @"title":title,
                              @"type":[NSNumber numberWithInt:type],
                              @"img":@"0"};
        ColumnModel *model = [[ColumnModel alloc]initWithDataDic:dic];
        [dataArray addObject:model];
//        [dic release];
    }
    data = dataArray;
    if (data.count<[collection_count intValue]) {
        self.tableView.isMore = false;
    }
    return data;
}
//下拉加载
-(void)pullUp:(NewsNightModelTableView *)tableView{
//    获取最后一个id
    ColumnModel *model = [_tableView.data lastObject];
    NSString *lastId = model.newsId;
    NSMutableArray *data = [[[NSMutableArray alloc]initWithArray:[self getData:lastId]]autorelease];
    [data addObjectsFromArray: _tableView.data];
    _tableView.data = data;

    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
    
}
-(void)reloadData{
    [_tableView reloadData];
}
-(void)tableView:(NewsNightModelTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NightModelContentViewController *nightModel = [[NightModelContentViewController alloc]init];
    ColumnModel *model =tableView.data[indexPath.row];
    nightModel.type = [model.type intValue];
    nightModel.newsId = [NSString stringWithFormat:@"%@",model.newsId];
    [self.navigationController pushViewController:nightModel animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    RELEASE_SAFELY(_tableView);
    [super dealloc];
}
@end
