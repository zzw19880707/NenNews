//
//  SubscribeViewController.m
//  东北新闻网
//
//  Created by tenyea on 14-2-8.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "SubscribeViewController.h"
#import "Uifactory.h"
#import "VedioAndImageModel.h"
#import "PlayerViewController.h"
#import "ColumnTabelViewController.h"
@interface SubscribeViewController (){
    VedioAndImageModel *_model ;
    BOOL _enable;
    
}

@end

@implementation SubscribeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"订阅";
    }
    return self;
}
//初始化按钮
-(NSArray *)_initButton {
    
    //栏目数组
    NSMutableArray *nameArrays = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:subscribe_column]];
    //    用于存放按钮
    NSMutableArray *buttonArrays = [[NSMutableArray alloc]init];
    
    //    用于存放tableview
    NSMutableArray *tableArrays = [[NSMutableArray alloc]init];
    for (int i =0; i<nameArrays.count; i++) {
        int columnId = [[nameArrays[i] objectForKey:@"columnId"] intValue];
        UIButton *button = [Uifactory createButton:[nameArrays[i] objectForKey:@"name"]];
        button.frame = CGRectMake(10 + 70*i, 0, 60, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.tag = 1000+ i;
        [buttonArrays addObject:button];
        
        VedioNightModelView *vedio = [[VedioNightModelView alloc]init];
        vedio.tag = 1300 +i;
        vedio.eventDelegate = self;
        vedio.frame = CGRectMake(340 *i, 0, ScreenWidth, ScreenHeight -44-20);
        vedio.columnID = columnId;
        vedio.VedioDelegate = self;
        vedio.type = 3;//视频
        vedio.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self getData:vedio cache:1];
        [tableArrays addObject:vedio];
        [vedio release];
        
    }
    //    用于存放按钮和tableview
    NSArray *arrays = @[buttonArrays,tableArrays];
    return arrays;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    初始化界面
    [self _initButton];
    self.isLoading = NO;
    _sc = [[BaseScrollView alloc]initwithButtons:[self _initButton] WithFrame:CGRectMake(0, 0, 320, ScreenHeight)];
    _sc.eventDelegate = self;
    [self.view addSubview:_sc];
    
    VedioNightModelView *table  = (VedioNightModelView *) VIEWWITHTAG( VIEWWITHTAG(_sc, 10001), 1300);
    [self getData:table cache:0];


}


#pragma mark UItableviewEventDelegate
//cache 0:正常缓存 1代表只读本地
-(void)getData :(VedioNightModelView *)tableView cache:(int)cache{
    [self getConnectionAlert];
    //    参数
    NSMutableDictionary *params  = [[NSMutableDictionary alloc]init];
    int count = [[NSUserDefaults standardUserDefaults]integerForKey:kpageCount];
    NSNumber *number = [NSNumber numberWithInt:((count+1)*10)];
    [params setValue:number forKey:@"count"];
    int columnID=tableView.columnID;
    [params setValue:[NSNumber numberWithInt:columnID] forKey:@"takePartId"];
    //    正常访问网络
    if (cache ==0) {
        [DataService requestWithURL:URL_getsubscribe_List andparams:params andhttpMethod:@"GET" completeBlock:^(id result) {
            tableView.lastDate = [NSDate date];
            tableView.isMore = true;
            NSArray *array =  [result objectForKey:@"videos"];
            if (array.count ==0) {
                [tableView doneLoadingTableViewData];
                return ;
            }
            NSMutableArray *listData = [[NSMutableArray alloc]init];
            
            for (NSDictionary *dic  in array) {
                VedioAndImageModel * model = [[VedioAndImageModel alloc]initWithDataDic:dic];
                [listData addObject:model];
                [model release];
            }
            tableView.data =listData;
            [tableView reloadData];

            [tableView doneLoadingTableViewData];
            
        } andErrorBlock:^(NSError *error) {
            [tableView doneLoadingTableViewData];
        }];
    }else{
        //        只读本地
        [DataService nocacheWithURL:URL_getsubscribe_List andparams:params completeBlock:^(id result) {
            tableView.isMore = true;
            NSArray *array =  [result objectForKey:@"videos"];
            if (array.count ==0) {
                [tableView doneLoadingTableViewData];
                return ;
            }
            NSMutableArray *listData = [[NSMutableArray alloc]init];
            for (NSDictionary *dic  in array) {
                VedioAndImageModel * model = [[VedioAndImageModel alloc]initWithDataDic:dic];
                [listData addObject:model];
                [model release];
            }
            tableView.data =listData;
            [tableView doneLoadingTableViewData];
            [tableView reloadData];
            
        } andErrorBlock:^(NSError *error) {
            [tableView doneLoadingTableViewData];
        }];
    }

}

//上拉刷新
-(void)pullDown:(VedioNightModelView *)tableView{
    if (![self getConnectionAlert]) {
        [tableView doneLoadingTableViewData];
        return;
    }
    [self getData:tableView cache:0];
    
}

//下拉加载
-(void)pullUp:(NewsNightModelTableView *)tableView{
    if (_isLoading ) {
        return;
    }
    
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
    [params setValue:[NSNumber numberWithInt:columnID] forKey:@"takePartId"];
    if (tableView.data.count>0) {
        VedioAndImageModel *model = [tableView.data lastObject];
        NSString *sinceID = model.newsId;
        [params setValue:sinceID forKey:@"sinceId"];
    }
    [self getConnectionAlert];
    self.isLoading = YES;

    [DataService requestWithURL:URL_getsubscribe_List andparams:params andhttpMethod:@"GET" completeBlock:^(id result) {
        NSArray *array =  [result objectForKey:@"videos"];
        NSMutableArray *listData = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic  in array) {
            VedioAndImageModel * model = [[VedioAndImageModel alloc]initWithDataDic:dic];
            [listData addObject:model];
        }
        
        [tableView doneLoadingTableViewData];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:tableView.data];
        [arr addObjectsFromArray:listData];
        tableView.data  = arr;

        if (listData.count < (count+1)*10) {
            tableView.isMore = false;
        }
        [tableView reloadData];
        self.isLoading = NO;

    } andErrorBlock:^(NSError *error) {
        [tableView doneLoadingTableViewData];
        self.isLoading = NO;

    }];
    
    
    
}

-(void)tableView:(VedioNightModelView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
#pragma mark VedioNightModelViewDelegate
-(void)selectedAction:(VedioAndImageModel *)model{
    if (model.videoUrl) {
        NSString *ktype =[DataCenter getConnectionAvailable];
        _model = model;
        if ([ktype isEqualToString:@"none"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:INFO_NetNoReachable
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }else if([ktype isEqualToString:@"wifi"]){
            
            [self play];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:INFO_Net3GReachable delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
            [alert show];
            [alert release];
        }
    }
    

}
-(void)play {
    NSURL *url = [NSURL URLWithString:_model.videoUrl];
    PlayerViewController *playerViewController = [[PlayerViewController alloc] initWithContentURL:url];
    playerViewController.moviePlayer.shouldAutoplay=YES;
    [self.appDelegate.menuCtrl presentMoviePlayerViewControllerAnimated:playerViewController];
}
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 ) {
        
    }else{
        [self play];
    }
}

-(void)addButtonAction{
    ColumnTabelViewController *columnVC = [[ColumnTabelViewController alloc]initWithType:1];
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
-(void)autoRefreshData:(VedioNightModelView *)tableView{
    [self getData:tableView cache:0];
}
//-(void)autoRefreshDatawithCache:(VedioNightModelView *)tableView{
//    [self getData:tableView cache:1];
//}
#pragma mark columnchangeDelegate
-(void)columnChanged:(NSArray *)array{
    _sc.buttonsNameArray = [self _initButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
