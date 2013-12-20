//
//  ColumnViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-20.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "ColumnViewController.h"

@interface ColumnViewController ()

@end

@implementation ColumnViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)_initcolumnname {
    //写入初始化文件
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *pathName = [plistPath1 stringByAppendingPathComponent:column_file_name];
    _columnNameArray = [[NSArray alloc]initWithContentsOfFile:pathName];
    _showNameArray = [[NSMutableArray alloc]init];
    _addNameArray = [[NSMutableArray alloc]init];

    for (int i = 0 ; i < _columnNameArray.count ; i++) {
        NSDictionary *dic = _columnNameArray[i];
        if ([[dic objectForKey:@"isShow"] boolValue]) {
            [_showNameArray addObject:dic];
            
        }else{
            [_addNameArray addObject:dic];
        }
        [dic release];
    }
}
-(int)division:(int) i count:(int)b{
    return  (i%b ==0 )?(i/b) : (i/b + 1);
    
}

-(void)_initShowView{
    _showBackgroundView = [[UIView alloc]init];
    _showBackgroundView.frame = CGRectMake(0, 0, ScreenWidth, 100);
    _showBackgroundView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_showBackgroundView];
    int i = [self division:_showNameArray.count count:4];
    _showBackgroundView.height += i*40;
    
    
    [self _initbutton:0];
    
}

-(void)_initAddView{
    _addBackgroundView = [[UIView alloc]init];
    _addBackgroundView.frame = CGRectMake(0, _showBackgroundView.height, ScreenWidth, ScreenHeight-_showBackgroundView.height);
    _addBackgroundView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_addBackgroundView];
}
-(void)_initbutton:(int)backgroundIndex{
    int count = _showNameArray.count;
    float width = 0.0f;
    float heigth = 50;
    for (int i = 0 ; i<count; i++) {
        NSDictionary *dic = _showNameArray[i];
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        button.tag = [[dic objectForKey:@"columid"] intValue];
        button.frame = CGRectMake(0+width, heigth, width, 40);
        button.backgroundColor = [UIColor blackColor];
        
        if (i%4 ==0) {
            heigth +=50;
            width = 0.0f;
            _showBackgroundView.height+=50;
        }else{
            width += 70.0f;
        }
        DLogPoint(button.origin);
        [_showBackgroundView addSubview:button];
        [button release];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initcolumnname];
    [self _initShowView];
    [self _initAddView];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
