//
//  BaseViewController.m
//  tabbartest
//
//  Created by 佐筱猪 on 13-10-15.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "BaseNavViewController.h"
#import "Reachability.h"
#import "FileUrl.h"
#import "NightModelContentViewController.h"
#import "BaseViewController+StatusBarStyle.h"
#import "ColumnModel.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize latitude=_latitude;
@synthesize longitude=_longitude;
#pragma mark 适配ios7
-(void)setStateBarHidden :(BOOL) statusBarHidden{
    if (WXHLOSVersion()>=7.0) {
        [self setStatusBarStyle:UIStatusBarStyleLightContent];
        [self setStatusBarHidden:statusBarHidden];
        
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:statusBarHidden];
    }
}
-(id)init{
    self = [super init];
 
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNews:) name:kPushNewsNotification object:nil];
    }
    return self;
}
-(void)pushNewswithColumn:(ColumnModel *)model {
    NSArray *viewControllers = self.navigationController.viewControllers;

    if (viewControllers.count > 1) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    NightModelContentViewController *nightModel = [[NightModelContentViewController alloc]init];
    
    //插入该cell已经选中
    NSString *newsId = model.newsId;
    NSString *newsAbstract =model.newsAbstract;
    NSString *img = model.img;
    NSString *sql = [NSString stringWithFormat:@"insert into columnData(newsId,title,newsAbstract,type,img,isselected) values('%@','%@','%@',%@,'%@',1) ;",newsId,model.title,newsAbstract,model.type,img];
    _po(sql);
    [self.db executeUpdate:sql];
    nightModel.newsAbstract = model.newsAbstract;
    nightModel.type = [model.type intValue];
    nightModel.newsId = [NSString stringWithFormat:@"%@",model.newsId];
    nightModel.ImageUrl = model.img;
    [self.navigationController pushViewController:nightModel animated:YES];
}
-(void)pushNews:(NSNotification *)notification {
    ColumnModel *model =(ColumnModel *)notification.object;
    [self pushNewswithColumn:model];
   
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(AppDelegate *)appDelegate{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    return  appDelegate;
}

#pragma mark - loading tips 加载提示
//判断当前是否有网络
-(BOOL) isConnectionAvailable{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:BASE_URL];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
}
//判断当前是否有网络
-(NSString *) getConnectionAvailable{
    NSString *isExistenceNetwork = @"none";
    Reachability *reach = [Reachability reachabilityWithHostName:BASE_URL];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = @"none";
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = @"wifi";
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = @"3g";
            //NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
}

//判断当前网络是否存在。存在则正常访问，不存在则提示当前网络不存在
-(BOOL)getConnectionAlert{
    if ([self isConnectionAvailable]) {
        return YES;
    }else{
        [self showHUD:INFO_NetNoReachable isDim:YES];
        [self performSelector:@selector(hideHUD) withObject:nil afterDelay:1];
        return NO;
    }
}
//显示加载提示
- (BOOL )showHUD:(NSString *)title isDim:(BOOL)isDim {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([self isConnectionAvailable]) {
        self.hud.labelText = title;
        self.hud.dimBackground = isDim;
        return YES;
    }else{
        self.hud.removeFromSuperViewOnHide =YES;
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = NSLocalizedString(INFO_NetNoReachable, nil);
        self.hud.minSize = CGSizeMake(132.f, 108.0f);
        [self.hud hide:YES afterDelay:3];
        return NO;
        
    }
    
}
//显示加载完成提示
- (void)showHUDComplete:(NSString *)title {
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.labelText = title;
}

//隐藏加载提示
- (void)hideHUD {
    [self.hud hide:YES];
}
//状态栏提示
-(void)showStaticTip:(BOOL)show title:(NSString *)title{
    if(_tipWindow==nil){
        _tipWindow =[[UIWindow alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        _tipWindow.windowLevel=UIWindowLevelStatusBar;
        _tipWindow.backgroundColor=[UIColor blackColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        label.textAlignment=UITextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor whiteColor];
        label.backgroundColor=[UIColor clearColor];
        label.tag=13;
        [_tipWindow addSubview:label];
        
        UIImageView *progress=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queue_statusbar_progress.png"]];
        progress.tag=14;
        progress.frame=CGRectMake(0, 20-6, 100, 6);
        
        [_tipWindow addSubview:progress];
        
    }
    UIImageView *progress=(UIImageView *)[_tipWindow viewWithTag:14];
    
    UILabel *tipLabel=(UILabel *)[_tipWindow viewWithTag:13];
    if (show) {
        tipLabel.text=title;
        _tipWindow.hidden=NO;
        //增加来回移动
        progress.left=0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:3];
        [UIView setAnimationRepeatCount:1000];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];//匀速移动
        progress.left=ScreenWidth-100;
        [UIView commitAnimations];
        
    }else{
        tipLabel.text=title;
        [self performSelector:@selector(removeTipWindow) withObject:nil afterDelay:2];
    }
    
}
-(void)removeTipWindow{
    _tipWindow.hidden=YES;
    [_tipWindow release];
    _tipWindow=nil;
}
- (void)viewDidLoad
{
    self.db = [FileUrl getDB];
    [self.db open];
    [super viewDidLoad];

    //设置当前网络环境
    self.network = [self getConnectionAvailable];
    //设置navegation背景颜色
    self.navigationController.navigationBar.tintColor = NenNewsgroundColor;
	[self.view setBackgroundColor:CLEARCOLOR];


    NSArray *viewControllers = self.navigationController.viewControllers;
    
    
        
    if (self.isCancelButton) {
//        UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cencel)];
//        self.navigationItem.leftBarButtonItem=[cancelItem autorelease];
        UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = NenNewsgroundColor;
        [button setImage:[UIImage imageNamed:@"navagiton_back.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 40, 40);
        //        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(cencel) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = [backItem autorelease];
    }else{
        if (viewControllers.count > 1 ) {
            UIButton *button = [[UIButton alloc]init];
            button.backgroundColor = NenNewsgroundColor;
            //        [button setTitle:@"返回" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"navagiton_back.png"] forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, 40, 40);
            //        button.showsTouchWhenHighlighted = YES;
            [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            self.navigationItem.leftBarButtonItem = [backItem autorelease];
        }
    }

}
#pragma mark ----按钮事件
-(void)cencel{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----内存管理
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    RELEASE_SAFELY(_db);
    RELEASE_SAFELY(_request);
    RELEASE_SAFELY(_hud);
    RELEASE_SAFELY(_network);
    DLOG(@"release :%@",[self class]);
    [super dealloc];
}
-(void)viewDidUnload{
    [_db close];
    [super viewDidUnload];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self hideHUD];
    [self.request clearDelegatesAndCancel];
    [super viewWillDisappear:animated];
}
-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    UILabel *titlelabel=[[UILabel alloc]initWithFrame:CGRectZero];
    titlelabel.font=[UIFont boldSystemFontOfSize:18.0f];
    titlelabel.backgroundColor= NenNewsgroundColor;
    titlelabel.text=title;
    titlelabel.textColor=NenNewsTextColor;
    [titlelabel sizeToFit];
    self.navigationItem.titleView = [titlelabel autorelease];
}
//提示登录对话框
-(void)alertLoginView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你尚未登录，是否登陆？" delegate:self cancelButtonTitle:@"否"  otherButtonTitles:@"是", nil];
    alert.tag = INT16_MAX;
    [alert show];
    [alert release];
}

#pragma mark 重写longitude\latitude

//定位
-(void)Location {
    if([CLLocationManager locationServicesEnabled]){
        //已经定位
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kisLocation]) {
//            [];
        }
        //重新定位
        else{
            CLLocationManager *locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            //设置不筛选，(距离筛选器distanceFilter,下面表示设备至少移动1000米,才通知委托更新）
            locationManager.distanceFilter = kCLDistanceFilterNone;
            //精度10米
            [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
            [locationManager startUpdatingLocation];
        }
    }else{
        alertContent(@"请在<设置>打开<定位服务>,以使用此功能");
    }
}

#pragma mark - CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
    
    [manager stopUpdatingLocation];
    self.longitude = newLocation.coordinate.longitude;
    self.latitude = newLocation.coordinate.latitude;
    
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
}
@end
