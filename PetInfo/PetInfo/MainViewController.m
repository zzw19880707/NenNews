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
#import "BaseNavViewController.h"
#import "DDMenuController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "ThemeManager.h"
#define firstimage @"http://a.hiphotos.baidu.com/image/w%3D2048/sign=9f5289ba0b55b3199cf9857577918326/4d086e061d950a7b32998b7f0bd162d9f3d3c9d9.jpg"
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
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kisLocation];

}
//添加rootview
-(void)_initViewController{
    _root = [[RootViewController alloc]init];
    
    LeftViewController *leftCtrl = [[LeftViewController alloc] init];
    RightViewController *rightCtrl = [[RightViewController alloc] init];
    
    
    BaseNavViewController *navViewController = [[BaseNavViewController alloc]initWithRootViewController:_root];
    
    //初始化左右菜单
    DDMenuController *menuCtrl = [[DDMenuController alloc] initWithRootViewController:navViewController];
    menuCtrl.leftViewController = leftCtrl;
    menuCtrl.rightViewController = rightCtrl;
    self.appDelegate.window.rootViewController = menuCtrl;
    self.appDelegate.menuCtrl = menuCtrl;
//    [navViewController release];
}
//进入应用后大图
-(void)_initBackgroundView {
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
    //广告图片
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-88);
    NSString *url = [[NSString alloc]init];
    if (![_userDefaults boolForKey:kisNotFirstLogin]) {
        url = firstimage;
    }else{
        url = [_userDefaults stringForKey:main_adImage_url];
    }
    [topImageView setImageWithURL:[NSURL URLWithString:url]];
    [_backgroundView addSubview:topImageView];
    [topImageView release];
    [self.view  addSubview: _backgroundView];
}

-(void)_initplist{
    //写入初始化文件
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *pathName = [plistPath1 stringByAppendingPathComponent:data_file_name];
    NSDictionary *dica = [[NSDictionary alloc]init];
    [dica writeToFile:pathName atomically:YES];
    
    //设置文件初始化
    NSString *settingPath = [NSHomeDirectory() stringByAppendingPathComponent: kSetting_file_name];
    [[NSFileManager defaultManager] createFileAtPath: settingPath contents: nil attributes: nil];
    _settingDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt: 1], kFont_Size, [NSNumber numberWithBool: YES], KNews_Push, nil];
    [_settingDic writeToFile: settingPath atomically: YES];
    
    
    //初始化菜单
    NSString *columnName = [plistPath1 stringByAppendingPathComponent:column_file_name];
    NSArray *columnsName = @[@"头条",@"体育",@"娱乐",@"科技",@"军事",@"中超",@"历史",@"本地",@"教育"];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for(int i= 0 ; i<columnsName.count ;i ++){
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[columnsName[i],(i>5)? @NO:@YES,[NSNumber numberWithInt:i]] forKeys:@[@"name",@"isShow",@"cloumID"]];
        [array addObject:dic];
        [dic release];
    }
    [array writeToFile:columnName atomically:YES];
}
#pragma mark UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    _userDefaults=[NSUserDefaults standardUserDefaults];

    [self _initLocation];
    
    //加载进入应用后大图
    [self _initBackgroundView];
    
    //设置夜间模式
    bool  nightModel=[_userDefaults boolForKey:kisNightModel];
    if (nightModel) {
        [ThemeManager shareInstance].nigthModelName =@"day";
    }else{
        [ThemeManager shareInstance].nigthModelName =@"night";
    }
    [[ThemeManager shareInstance] setPush];
    //第一次登陆
    if (![_userDefaults boolForKey:kisNotFirstLogin]) {
        [self _initplist];
        #warning 推送绑定
        [BPush bindChannel];
        [self performSelector:@selector(viewDidEnd) withObject:nil afterDelay:3];
    }else{
        //图片最多加载5秒
        [self performSelector:@selector(_removeBackground) withObject:nil afterDelay:5];
//        [self performSelector:@selector(viewDidEnd) withObject:nil afterDelay:1];

    }
    self.view.backgroundColor = [UIColor redColor];
}
//移除登陆广告大图
-(void)_removeBackground{
    [UIView animateWithDuration:0.5 animations:^{
        _backgroundView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        RELEASE_SAFELY(_backgroundView);
        //隐藏状态
        [self setStateBarHidden:NO];
        [self _initViewController];
    }];
    
}
//增加引导图
-(void)_addGuidePageView{
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
    _scrollView.delegate = self;
   
    //增加引导页图片
    for (int i = 0 ; i < imageNameArray.count  ; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i*320 , 0, ScreenWidth, ScreenHeight);
        [imageView setImage:[UIImage imageNamed:imageNameArray[i]]];
        [_scrollView addSubview:imageView];
        [imageView  release];
    }
    //进入主界面按钮
    UIButton *button = [[UIButton alloc]init];
    button.titleLabel.numberOfLines = 2;
    button.backgroundColor = CLEARCOLOR;
    button.titleLabel.backgroundColor = CLEARCOLOR;
    [button setTitle:@"进入\n东北新闻网" forState:UIControlStateNormal];
    [button setTitleColor:NenNewsTextColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(320*imageNameArray.count -150, 300, 100, 50);
    [_scrollView addSubview:button];
    [button release];
    [self.view addSubview:_scrollView];
    
    //增加pageview
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.frame = CGRectMake((ScreenWidth-100)/2, ScreenHeight -70, 100, 30);
    pageControl.tag = 100;
    pageControl.currentPage = 0 ;
    pageControl.numberOfPages = imageNameArray.count;
    pageControl.backgroundColor = [UIColor clearColor];
    [pageControl addTarget:self action:@selector(pageindex:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    [pageControl release];
}
//引导图
-(void)viewDidEnd{
    [UIView animateWithDuration:0.5 animations:^{
        _backgroundView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        RELEASE_SAFELY(_backgroundView);
    }];
    [self _addGuidePageView];
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
        [userDefaults setFloat:_longitude forKey:kuser_longitude];
        [userDefaults setFloat:_latitude forKey:kuser_latitude];
        [userDefaults setBool:NO forKey:kisLocation];
    }
}
#pragma mark scrolldelegate 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int pageindex = scrollView.contentOffset.x / 320 ;
    UIPageControl *pageControl = (UIPageControl *) [self.view viewWithTag:100];
    pageControl.currentPage = pageindex;
}

#pragma mark 按钮事件
- (void)enter{
    UIPageControl *pageControl = (UIPageControl *)[self.view viewWithTag:100] ;
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.alpha = 0 ;
        pageControl.alpha = 0 ;
    } completion:^(BOOL finished) {
        //隐藏状态
        [self setStateBarHidden:NO];
        [_userDefaults setBool:YES forKey:kisNotFirstLogin];
        [pageControl removeFromSuperview];
        [self _initViewController];

    }];
}
//pagecontrol 事件
- (void)pageindex:(UIPageControl *)pagecontrol{
    CGRect frame = CGRectMake(pagecontrol.currentPage* ScreenWidth, 0, ScreenWidth, ScreenHeight);
    [_scrollView scrollRectToVisible:frame animated:YES];
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
    [userDefaults setFloat:_longitude forKey:kuser_longitude];
    [userDefaults setFloat:_latitude forKey:kuser_latitude];
    [userDefaults setBool:YES forKey:kisLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    _po([error localizedDescription]);
    [manager stopUpdatingLocation];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:kisLocation];
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
    if (![userDefaults boolForKey:kisNotFirstLogin]) {
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
