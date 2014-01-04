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

@interface RootViewController ()

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
        int columnId = [[nameArrays[i] objectForKey:@"cloumID"] intValue];
        UIButton *button = [Uifactory createButton:[nameArrays[i] objectForKey:@"name"]];
        button.frame = CGRectMake(10 + 70*i, 0, 60, 30);

        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.tag = 1000+ i;
        [buttonArrays addObject:button];
        
        
        NewsNightModelTableView *newsTableView = [[NewsNightModelTableView alloc]initwithColumnID:columnId];
        newsTableView.frame = CGRectMake(340 *i, 0, ScreenWidth, ScreenHeight -40);
        newsTableView.eventDelegate = self;
        newsTableView.changeDelegate = self;
        
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

#pragma mark
#pragma mark UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initNavagationbarButton];

    _sc = [[BaseScrollView alloc]initwithButtons:[self _initButton] WithFrame:CGRectMake(0, 0, 320, ScreenHeight)];
    _sc.eventDelegate = self;
    [self.view addSubview:_sc];

}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //    开启左滑、右滑菜单
    [self.appDelegate.menuCtrl setEnableGesture:YES];
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
        nightModel.titleID = [imageData[index] objectForKey:@"titleID"] ;
        nightModel.titleID = [imageData[index] objectForKey:@"type"];
        [self.navigationController pushViewController:nightModel animated:YES];
    }
}
#pragma mark UItableviewEventDelegate
//上拉刷新
-(void)pullDown:(NewsNightModelTableView *)tableView{
    
    //    参数
    NSMutableDictionary *params  = [[NSMutableDictionary alloc]init];
    int count = [[NSUserDefaults standardUserDefaults]integerForKey:kpageCount];
    NSNumber *number = [NSNumber numberWithInt:(count*10)];
    [params setValue:number forKey:@"count"];
    int columnID=tableView.columnID;
    [params setValue:[NSNumber numberWithInt:columnID] forKey:@"columnID"];
    if (tableView.data.count>0) {
        ColumnModel *model = tableView.data[0];
        int sinceID = [model.titleId intValue];
        [params setValue:[NSNumber numberWithInt:sinceID] forKey:@"maxId"];
    }
    
    //    [params setValue:<#(id)#> forKey:@"maxId"];
    
    [DataService requestWithURL:URL_getColumn_List andparams:params andhttpMethod:@"POST" completeBlock:^(id result) {
        NSArray *array =  [result objectForKey:@"data"];
        NSMutableArray *listData = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic  in array) {
            ColumnModel * model = [[ColumnModel alloc]initWithDataDic:dic];
            [listData addObject:model];
        }
        tableView.data =listData;
        tableView.imageData = [result objectForKey:@"picture"];
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
    int columnID=tableView.columnID;
    [params setValue:[NSNumber numberWithInt:columnID] forKey:@"columnID"];
    if (tableView.data.count>0) {
        ColumnModel *model = tableView.data[tableView.data.count];
        int sinceID = [model.titleId intValue];
        [params setValue:[NSNumber numberWithInt:sinceID] forKey:@"sinceId"];
    }
    
    [DataService requestWithURL:URL_getColumn_List andparams:params andhttpMethod:@"POST" completeBlock:^(id result) {
        NSArray *array =  [result objectForKey:@"data"];
        NSArray *imageArray = [result objectForKey:@"picture"];
        NSMutableArray *listData = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic  in array) {
            ColumnModel * model = [[ColumnModel alloc]initWithDataDic:dic];
            [listData addObject:model];
        }
        [tableView doneLoadingTableViewData];
        [listData addObjectsFromArray:tableView.data];
        
        tableView.data  = listData;
        tableView.imageData = imageArray;
        [tableView reloadData];
    } andErrorBlock:^(NSError *error) {
        [tableView doneLoadingTableViewData];
        
    }];
    
}
-(void)tableView:(NewsNightModelTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.imageData.count >0&&indexPath.section==0) {
        
    }else{
        NightModelContentViewController *nightModel = [[NightModelContentViewController alloc]init];
        ColumnModel *model =tableView.data[indexPath.row];
        nightModel.type = @"3";//model.type;
        nightModel.titleID = [NSString stringWithFormat:@"%@",model.titleId];
        [self.navigationController pushViewController:nightModel animated:YES];
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
    _sc.buttonsNameArray = array;
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
