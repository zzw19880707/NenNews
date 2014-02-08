//
//  SubscribeViewController.m
//  东北新闻网
//
//  Created by tenyea on 14-2-8.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "SubscribeViewController.h"
#import "Uifactory.h"
#import "VedioNightModelView.h"
@interface SubscribeViewController ()

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
//    初始化背景视图
    self.view = [Uifactory createScrollView];
//    初始化界面
    [self _initButton];
    
    _sc = [[BaseScrollView alloc]initwithButtons:[self _initButton] WithFrame:CGRectMake(0, 0, 320, ScreenHeight)];
//    _sc.eventDelegate = self;
    [self.view addSubview:_sc];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
