//
//  RootViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-19.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "RootViewController.h"
#import "BaseScrollView.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//初始化tableview
-(NSArray *)_initUIView {
    NSMutableArray *arrays = [[NSMutableArray alloc]init];
    arrays = [[NSMutableArray alloc]init];
    for (int i =0; i<10; i++) {
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
    NSMutableArray *arrays = [[NSMutableArray alloc]init];
    for (int i =0; i<10; i++) {
        UIButton *button =[[UIButton alloc]init];
        [button setTitle:[NSString stringWithFormat:@"title%d",i] forState:UIControlStateNormal];
        [button setTitleColor:NenNewsTextColor forState:UIControlStateNormal];
        button.backgroundColor = NenNewsgroundColor;
        button.frame = CGRectMake(10 + 70*i, 0, 60, 30);
        [arrays addObject:button];
        [button release];
    }
    return arrays;
}
#pragma mark UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    BaseScrollView *sc = [[BaseScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 350) andButtons:[self _initButton] andContents:[self _initUIView]];
    [self.view addSubview:sc];
}
#pragma mark 内存管理
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
