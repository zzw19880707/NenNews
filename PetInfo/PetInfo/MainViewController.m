//
//  MainViewController.m
//  PetInfo
//
//  Created by 佐筱猪 on 13-11-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "MainViewController.h"
#import "Reachability.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "BaseNavViewController.h"
#import "DDMenuController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "ThemeManager.h"
#import "FileUrl.h"
#import "FMDB/src/FMDatabase.h"
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
    backImageView.frame = CGRectMake(0, ScreenHeight-100, ScreenWidth, 88);
    [_backgroundView addSubview:backImageView];
    [backImageView release];
    //广告图片
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-100);
    NSString *url = [[NSString alloc]init];
    if (![_userDefaults boolForKey:kisNotFirstLogin]) {
        url = firstimage;
        [_userDefaults setValue:firstimage forKey:main_adImage_url];
        [_userDefaults synchronize];
    }else{
//        当前无网络
        if ([[self getConnectionAvailable] isEqualToString:@"none"]) {
            url = [_userDefaults stringForKey:main_adImage_url];
            [topImageView setImageWithURL:[NSURL URLWithString:url]];
            [_backgroundView addSubview:topImageView];
            [topImageView release];
            [self.view  addSubview: _backgroundView];
        }else{//有网络，访问ao接口 获取图片地址
            [DataService requestWithURL:URL_AO andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
                NSDictionary *dic = [result objectForKey:@"AoPicture"];
                if (dic==nil) {
                    NSString  *Aourl = [dic objectForKey:@"pictureUrl"];
                    [topImageView setImageWithURL:[NSURL URLWithString:Aourl]];
                    [_userDefaults setValue:Aourl forKey:main_adImage_url];
                    [_userDefaults synchronize];
                    [_backgroundView addSubview:topImageView];
                    [topImageView release];
                }else{
                    NSString *Aourl = [_userDefaults stringForKey:main_adImage_url];
                    [topImageView setImageWithURL:[NSURL URLWithString:Aourl]];
                    [_backgroundView addSubview:topImageView];
                    [topImageView release];

                }
                
                [self.view  addSubview: _backgroundView];
            } andErrorBlock:^(NSError *error) {
                
            }];
        }
    }
    
}
-(void)_initDB{
    //初始化数据库
    FMDatabase *db = [FileUrl getDB];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
////    栏目表
////    栏目id   栏目名称  是否有主图  是否显示
//    [db executeUpdate:@"CREATE TABLE columnList (column INTEGER PRIMARY KEY, columnName TEXT, isImage INTEGER, isshow INTEGER)"];
//    NSArray *columnsName = @[@"头条",@"辽宁",@"文娱",@"社会",@"时尚",@"教育",@"民生",@"英语",@"新农村建设",@"旅游",@"财经",@"体育"];
//    for (int i = 0 ; i <columnsName.count; i++) {
////        NSString *sql = ;
//        [db executeUpdate:[NSString stringWithFormat:@"insert into columnList VALUES (%d,'%@',%d,%d);",i+1,columnsName[i],0,(i<7?1:0)]];
//    }
    
//    收藏表
//    titleid  标题  type类型
    [db executeUpdate:@"CREATE TABLE collectionList (newsId TEXT PRIMARY KEY, title TEXT, type INTEGER)"];
//   数据源列表
    
//    1.columndata表
//    titleid type类型  newsAbstract描述 title标题 img主图  isselected是否选过DEFAULT 0
    [db executeUpdate:@"CREATE TABLE columnData (newsId TEXT PRIMARY KEY, title TEXT, newsAbstract  TEXT, type INTEGER,img TEXT, isselected INTEGER DEFAULT 0)"];
//    2.contentdata表
//    titleid title标题 content新闻内容（栏目id_news_newsId.json） createtime创建时间 comAddress来源 url:新闻源地址
//    [db executeUpdate:@"CREATE TABLE contentdata (newsId TEXT PRIMARY KEY, title TEXT, content TEXT, pubtime TEXT,comeAddress TEXT, url TEXT)"];
//    3.linkNews表 相关新闻
//    abnewsid   newsid主新闻  title标题   titleid标题id  type（0代表相关，1代表专题）
//    [db executeUpdate:@"CREATE TABLE linkNews (linkNewsId TEXT PRIMARY KEY, newsId TEXT, title TEXT, titleId TEXT,type INTEGER )"];
}
-(void)_initplist{
    NSString *plistPath1 = [FileUrl getDocumentsFile];
    //写入初始化数据文件
    NSString *pathName = [plistPath1 stringByAppendingPathComponent:data_file_name];
    NSDictionary *dica = [[NSDictionary alloc]init];
    [dica writeToFile:pathName atomically:YES];

//    搜藏列表
    NSString *collectionName = [plistPath1 stringByAppendingPathComponent:kCollection_file_name];
    [dica writeToFile:collectionName atomically:YES];
    
    //搜索历史文件
    NSString *searchPath = [plistPath1 stringByAppendingPathComponent:kSearchHistory_file_name];
    NSArray *searchArray = [[NSArray alloc]init];
    [searchArray writeToFile:searchPath atomically:YES];
    
    //设置夜间模式
    [_userDefaults setBool:YES forKey:kisNightModel];
    [_userDefaults setInteger:1 forKey:kpageCount];
    [_userDefaults synchronize];
    
    //初始化菜单
    NSString *columnshowName = [plistPath1 stringByAppendingPathComponent:column_show_file_name];
    NSArray *columnsshowName = @[@"头条",@"辽宁",@"文娱",@"社会",@"时尚",@"教育"];
    NSMutableArray *showarray = [[NSMutableArray alloc]init];
    for(int i= 1 ; i<columnsshowName.count+1 ;i ++){
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[columnsshowName[i-1],[NSNumber numberWithInt:i],[NSNumber numberWithInt:1]] forKeys:@[@"name",@"columnId",@"showimage"]];
        [showarray addObject:dic];
        [dic release];
    }
    [showarray writeToFile:columnshowName atomically:YES];
    
    NSString *columnName = [plistPath1 stringByAppendingPathComponent:column_disshow_file_name];
    NSArray *columnsName = @[@"民生",@"英语",@"新农村建设",@"旅游",@"财经",@"体育"];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for(int i= 1 ; i<columnsName.count ;i ++){
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[columnsName[i-1],[NSNumber numberWithInt:(i+6)],[NSNumber numberWithInt:0]] forKeys:@[@"name",@"columnId",@"showimage"]];
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
    [self Location];
    //加载进入应用后大图
    [self _initBackgroundView];
    //第一次登陆
    if (![_userDefaults boolForKey:kisNotFirstLogin]) {
        [self _initDB];
        [self _initplist];

        [self performSelector:@selector(viewDidEnd) withObject:nil afterDelay:3];
    }else{
        //图片最多加载5秒
        [self performSelector:@selector(_removeBackground) withObject:nil afterDelay:5];
//        [self performSelector:@selector(viewDidEnd) withObject:nil afterDelay:1];

    }
    //设置夜间模式
    bool  nightModel=[_userDefaults boolForKey:kisNightModel];
    if (nightModel) {
        [ThemeManager shareInstance].nigthModelName =@"day";
    }else{
        [ThemeManager shareInstance].nigthModelName =@"night";
    }
    [[ThemeManager shareInstance] setPush];
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
    [button setTitleColor:NenNewsgroundColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(320*imageNameArray.count -150, ScreenHeight-180, 100, 50);
    [_scrollView addSubview:button];
    [button release];
    [self.view addSubview:_scrollView];
    
    //增加pageview
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.frame = CGRectMake((ScreenWidth-100)/2, ScreenHeight -70, 100, 30);
    pageControl.tag = 100;
    if (WXHLOSVersion()>=6.0) {
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.currentPageIndicatorTintColor = NenNewsgroundColor;
    }
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
        [_userDefaults synchronize];
        [pageControl removeFromSuperview];
        [self _initViewController];

    }];
}
//pagecontrol 事件
- (void)pageindex:(UIPageControl *)pagecontrol{
    CGRect frame = CGRectMake(pagecontrol.currentPage* ScreenWidth, 0, ScreenWidth, ScreenHeight);
    [_scrollView scrollRectToVisible:frame animated:YES];
}
#pragma mark Location
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
        [userDefaults setValue:@"101070101" forKey:kLocationCityCode];
        [userDefaults synchronize];
    }
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
//    获取当前城市名称
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       
                       for (CLPlacemark *place in placemarks) {
                           NSLog(@"locality,%@",place.locality);               // 市
                           NSString *citycode = [[NSBundle mainBundle]pathForResource:@"citycode" ofType:@"plist"];
                           NSDictionary *dic =[[NSDictionary alloc]initWithContentsOfFile:citycode];
                           NSString *code = [dic objectForKey:place.locality];
                           if (code ==nil) {
                               code = @"101070101";
                           }
                           [userDefaults setValue:code forKey:kLocationCityCode];
                           [userDefaults synchronize];
                       }
                   }];

    
    [userDefaults setBool:YES forKey:kisLocation];
    [userDefaults synchronize];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    _po([error localizedDescription]);
    [manager stopUpdatingLocation];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:kisLocation];
    [userDefaults setValue:@"101070101" forKey:kLocationCityCode];
    [userDefaults synchronize];

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
