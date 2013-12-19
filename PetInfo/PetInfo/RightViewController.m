//
//  RightViewController.m
//  东北新闻网
//
//  Created by 佐筱猪 on 13-12-18.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//初始化背景图
-(void)_initFrame {
    CGRect frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.view.frame =frame;
    [self.view viewWithTag:400].frame = frame;
    [self.view viewWithTag:500].frame = frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initFrame];
}

#pragma mark 内存管理
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectAction:(UIButton *)sender {
    UILabel *label =(UILabel *)VIEWWITHTAG(self.view, 1022);

    switch (sender.tag) {
        case 1000:
            
            break;
        case 1001:
            
            break;
        case 1002://夜间模式
            if ([label.text isEqualToString:@"夜  间"]) {
                label.text = @"白  天";
            }else{
                label.text = @"夜  间";
            }
            break;
        case 1003:
            
            break;
        case 1004:
            
            break;
        case 1005:
            
            break;

        default:
            break;
    }
}
@end
