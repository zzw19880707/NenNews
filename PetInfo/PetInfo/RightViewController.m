//
//  RightViewController.m
//  东北新闻网
//
//  Created by 佐筱猪 on 13-12-18.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "RightViewController.h"
#import "ThemeManager.h"
#import "SettingViewController.h"
#import "BaseNavViewController.h"
#import "SearchViewController.h"
#import "WeatherViewController.h"
#import "LoginViewController.h"
#import "UINavigationController+PushAnimated.h"
@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.frame =CGRectMake(0, 0, ScreenWidth,ScreenHeight);
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
}
//初始化背景图
-(void)_initFrame {
    CGRect frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.view.frame =frame;
    [self.view viewWithTag:400].frame = frame;
    [self.view viewWithTag:500].frame = frame;
    //夜间 白天模式
    UILabel *label =(UILabel *)VIEWWITHTAG(self.view, 1022);
    bool  nightModel=[[NSUserDefaults standardUserDefaults] boolForKey:kisNightModel];
    if (nightModel) {
        label.text = @"夜  间";
    }else{
        label.text = @"白  天";
    }
    
    //隐藏登陆
    UILabel *login = (UILabel *)VIEWWITHTAG(self.view, 1020);
    [login setHidden:YES];
    UIButton *loginButton = (UIButton *)VIEWWITHTAG(self.view, 1000);
    [loginButton setHidden:YES];
    
    [self getWeather];
   

}
-(void)getWeather {
    if ([[self getConnectionAvailable] isEqualToString:@"none"]) {
        
    }else{
        DataService *service = [[DataService alloc]init];
        service.eventDelegate = self;
        NSString *locationcityid = [[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityCode];
        NSString *url = [Weather_simple_URL stringByAppendingString:[NSString stringWithFormat:@"%@%@",locationcityid,@".html"]];
        [service requestWithURL:url andparams:nil isJoint:NO andhttpMethod:@"GET"];
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request{
}
-(void)requestFinished:(id)result{
    NSDictionary *dic = [result objectForKey:@"weatherinfo"];
    //当日天气
    UILabel *weatherLabel =(UILabel *)VIEWWITHTAG(self.view, 1021);
    weatherLabel.text = [NSString stringWithFormat:@"%@/%@",[dic objectForKey:@"temp2"],[dic objectForKey:@"temp1"]];
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
    SettingViewController *set = [[[SettingViewController alloc]init]autorelease ];
    set.isCancelButton = YES;
    SearchViewController *search = [[[SearchViewController alloc]init]autorelease];
    search.isCancelButton = YES;
    WeatherViewController *weather =[[[WeatherViewController alloc]init]autorelease];
    weather.isCancelButton = YES;
//    LoginViewController *login = [[[LoginViewController alloc]init]autorelease];
//    login.isCancelButton = YES;

    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    switch (sender.tag) {
        case 1000://登陆
//            [self.appDelegate.menuCtrl presentModalViewController:[[[BaseNavViewController alloc]initWithRootViewController: login]autorelease] animated:YES];
            
            break;
        case 1001:
            [self.appDelegate.menuCtrl presentModalViewController:[[[BaseNavViewController alloc]initWithRootViewController: weather]autorelease] animated:YES];
            [self getWeather];
            break;
        case 1002://夜间模式
            
            if ([label.text isEqualToString:@"夜  间"]) {
                label.text = @"白  天";
                [ThemeManager shareInstance].nigthModelName = @"night";
                [userdefaults setBool:NO forKey:kisNightModel];
                [userdefaults synchronize];
                [[NSNotificationCenter defaultCenter]postNotificationName:kNightModeChangeNofication object:nil];
            }else{
                label.text = @"夜  间";
                [ThemeManager shareInstance].nigthModelName = @"day";
                [userdefaults setBool:YES forKey:kisNightModel];
                [userdefaults synchronize];
                [[NSNotificationCenter defaultCenter]postNotificationName:kNightModeChangeNofication object:nil];
            }
            [self.appDelegate.menuCtrl showRootController:YES];
            break;
        case 1003:
            [self.appDelegate.menuCtrl presentModalViewController:[[[BaseNavViewController alloc]initWithRootViewController: search]autorelease] animated:YES];
            break;
        case 1004:
            //首页开始下载
            [[NSNotificationCenter defaultCenter] postNotificationName:kofflineBeginNofication object:nil];
            [self.appDelegate.menuCtrl showRootController:YES];
            break;
        case 1005:
            [self.appDelegate.menuCtrl presentModalViewController:[[[BaseNavViewController alloc]initWithRootViewController: set]autorelease] animated:YES];
            break;

        default:
            break;
    }
}
@end
