//
//  RootViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-19.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "RootViewController.h"
#import "ColumnViewController.h"
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
//初始化tableview
-(NSArray *)_initUIView {
    
    
    NSMutableArray *arrays = [[NSMutableArray alloc]init];
    arrays = [[NSMutableArray alloc]init];
    for (int i =0; i<6; i++) {
        UILabel *view=[[UILabel alloc]init];
        view.text =[NSString stringWithFormat: @"content%d",i];
        view.textColor = NenNewsTextColor;
        view.backgroundColor = NenNewsgroundColor;
        view.frame = CGRectMake(0, 0, 320, 40);
        [arrays addObject: view];
    }
    return arrays;
}
//初始化按钮
-(NSArray *)_initButton {
    
    //写入初始化文件
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *pathName = [plistPath1 stringByAppendingPathComponent:column_file_name];
    NSArray *columnName = [[NSArray alloc]initWithContentsOfFile:pathName];
    NSMutableArray *nameArrays = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < columnName.count ; i++) {
        NSDictionary *dic = columnName[i];
        if ([[dic objectForKey:@"isShow"] boolValue]) {
            [nameArrays addObject:[dic objectForKey:@"name"]];
        }
        [dic release];
    }
    
    
    
    NSMutableArray *arrays = [[NSMutableArray alloc]init];
    for (int i =0; i<nameArrays.count; i++) {
        UIButton *button =[[UIButton alloc]init];
        [button setTitle:nameArrays[i] forState:UIControlStateNormal];
        [button setTitleColor:NenNewsTextColor forState:UIControlStateNormal];
        button.backgroundColor = NenNewsgroundColor;
        button.frame = CGRectMake(10 + 70*i, 0, 60, 30);
        [arrays addObject:button];
        [button release];
    }
    return arrays;
}

-(void)_initNavagationbarButton {
    //添加状态栏按钮
    UIButton *leftButton = [[UIButton alloc]init];
    leftButton.backgroundColor=CLEARCOLOR;
    leftButton.frame=CGRectMake(0, 0, 20, 20);
    [leftButton setImage:[UIImage imageNamed:@"left_item_button.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setShowsTouchWhenHighlighted:YES];
    
    UIButton *rightButton = [[UIButton alloc]init];
    rightButton.backgroundColor=CLEARCOLOR;
    rightButton.frame=CGRectMake(0, 0, 20, 20);
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
    ColumnViewController *columnVC = [[ColumnViewController alloc]init];
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
    
    
    BaseScrollView *sc = [[BaseScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, ScreenHeight) andButtons:[self _initButton] andContents:[self _initUIView]];
    sc.eventDelegate = self;
    [self.view addSubview:sc];
    [sc release];
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

#pragma mark 按钮事件
- (void)leftAction {
    [self.appDelegate.menuCtrl showLeftController:YES];
}
- (void)rightAction {
    [self.appDelegate.menuCtrl showRightController:YES];

}

#pragma mark 内存管理
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
