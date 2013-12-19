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
        self.title = @"东北新闻网";
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
