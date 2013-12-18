//
//  MainViewController.m
//  PetInfo
//
//  Created by 佐筱猪 on 13-11-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "MainViewController.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
#pragma mark init
//初始化数据
-(void)_initLocation{
    _longitude = 0;
    _latitude = 0;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isLocation];

}

#pragma mark UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initLocation];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //隐藏状态栏
    
    [self setStateBarHidden:YES];
    _backgroundView =[[UIView alloc]init];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    //进入后大图
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Main_Background_write.png"]];
    view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [_backgroundView addSubview:view];
    

    //load背景logo图图片
    UIImage *backImage= [[UIImage imageNamed:@"main_background_logo.png"] autorelease];    UIImageView *backImageView =[[UIImageView alloc]initWithImage:backImage];
    backImageView.frame = CGRectMake(0, ScreenHeight-88, ScreenWidth, 88);
    [_backgroundView addSubview:backImageView];
    [backImageView release];
    
    
    
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-88);
    [topImageView setImageWithURL:[NSURL URLWithString:@"http://a.hiphotos.baidu.com/image/w%3D2048/sign=9f5289ba0b55b3199cf9857577918326/4d086e061d950a7b32998b7f0bd162d9f3d3c9d9.jpg"]];
    [_backgroundView addSubview:topImageView];
    [topImageView release];
    
    
    //第一次登陆
    if (![userDefaults boolForKey:isNotFirstLogin]) {

        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *plistPath1 = [paths objectAtIndex:0];
        NSString *pathName = [plistPath1 stringByAppendingPathComponent:@"HomeCellData.plist"];
        NSDictionary *dica = [[NSDictionary alloc]init];
        [dica writeToFile:pathName atomically:YES];
#warning 推送绑定
        [BPush bindChannel];
        [self performSelector:@selector(viewDidEnd) withObject:nil afterDelay:1];
        [userDefaults setBool:YES forKey:isNotFirstLogin];

    }else{
        //图片最多加载5秒
        [self performSelector:@selector(viewDidEnd) withObject:nil afterDelay:1];
        
    }
    [self.view  addSubview: _backgroundView];
    self.view.backgroundColor = [UIColor redColor];
    

}
//引导图
-(void)viewDidEnd{
    //引导页图片名
    NSArray *imageNameArray = @[@"main_guide_page_first.png",@"main_guide_page_second.png",@"main_guide_page_third.png",@"main_guide_page_fourth.png"];
    //引导页
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _scrollView.contentSize = CGSizeMake(320 *imageNameArray.count , ScreenHeight);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    for (int i = 0 ; i < imageNameArray.count  ; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i*320 , 0, ScreenWidth, ScreenHeight);
        [imageView setImage:[UIImage imageNamed:imageNameArray[i]]];
        [_scrollView addSubview:imageView];
        [imageView  release];
    }
    UIButton *button = [[UIButton alloc]init];
    button.titleLabel.numberOfLines = 2;
    button.backgroundColor = NenNewsgroundColor;
    button.titleLabel.backgroundColor = NenNewsgroundColor;
    [button setTitle:@"进入\n东北新闻网" forState:UIControlStateNormal];
    [button setTitleColor:NenNewsTextColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(320*imageNameArray.count -150, 300, 100, 50);
    
    [_scrollView addSubview:button];
    [button release];
    [self.view addSubview:_scrollView];
}
//定位
-(void)Location
{
    //开启定位服务
    if([CLLocationManager locationServicesEnabled]){
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        //设置不筛选，(距离筛选器distanceFilter,下面表示设备至少移动1000米,才通知委托更新）
        locationManager.distanceFilter = kCLDistanceFilterNone;
        //精度10米
        [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [locationManager startUpdatingLocation];
    }else{//未开启定位服务
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setFloat:_longitude forKey:user_longitude];
        [userDefaults setFloat:_latitude forKey:user_latitude];
        [userDefaults setBool:NO forKey:isLocation];
    }
}

#pragma mark 按钮事件
- (void)enter{
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.alpha = 0 ;
    } completion:^(BOOL finished) {
        //隐藏状态
        
        [self setStateBarHidden:NO];
    }];
}


#pragma mark - CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    _longitude = newLocation.coordinate.longitude;
    _latitude = newLocation.coordinate.latitude;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:_longitude forKey:user_longitude];
    [userDefaults setFloat:_latitude forKey:user_latitude];
    [userDefaults setBool:YES forKey:isLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    _po([error localizedDescription]);
    [manager stopUpdatingLocation];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:isLocation];
}

#pragma mark asirequest delegate
-(void)requestFinished:(id)result
{


    
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *pathName = [plistPath1 stringByAppendingPathComponent:@"HomeCellData.plist"];

    NSMutableDictionary * dic =[[NSMutableDictionary alloc] initWithContentsOfFile:pathName];

}
-(void)requestFailed:(ASIHTTPRequest *)asirequest
{
    _po([[asirequest error] localizedDescription]);
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:isNotFirstLogin]) {
//        [self RemoveandInit];
    }
}



#pragma mark 内存管理
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    RELEASE_SAFELY(_backgroundView);
    RELEASE_SAFELY(_scrollView);
    [super dealloc];
}
@end
