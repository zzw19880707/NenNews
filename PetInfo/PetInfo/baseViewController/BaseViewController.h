//
//  BaseViewController.h
//  tabbartest
//
//  Created by 佐筱猪 on 13-10-15.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import <CoreLocation/CoreLocation.h>
@class FMDatabase;
@class MBProgressHUD;
@interface BaseViewController : UIViewController <UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate>{
    UIWindow *_tipWindow;
}

//@property(nonatomic,assign)BOOL isBackButton; //navigation 返回

//返回appdelegate
-(AppDelegate *)appDelegate;
//显示加载提示
- (BOOL)showHUD:(NSString *)title isDim:(BOOL)isDim;
//显示加载完成提示
- (void)showHUDComplete:(NSString *)title;
//隐藏加载提示
- (void)hideHUD;
//设置状态栏提示
-(void)showStaticTip:(BOOL)show title:(NSString *)title;
//提示登录对话框
-(void)alertLoginView;
//定位方法
-(void)Location;
//判断当前网络情况
-(NSString *) getConnectionAvailable;
//判断当前网络是否存在。存在则正常访问，不存在则提示当前网络不存在
-(BOOL)getConnectionAlert;
//根据model push新闻
-(void)pushNewswithColumn:(ColumnModel *)model;
//经纬度
@property (nonatomic,assign) float longitude;
@property (nonatomic,assign) float latitude;
//取消按钮
@property (nonatomic,assign)BOOL isCancelButton;
//ASI访问请求。用于取消异步访问
@property (nonatomic,retain) ASIHTTPRequest *request;
//加载框
@property(nonatomic,retain)MBProgressHUD *hud;
//当前网络状态
@property (nonatomic,retain)NSString *network;
//数据库
@property (nonatomic,retain) FMDatabase *db;


-(void)setStateBarHidden :(BOOL) statusBarHidden;
-(void)setTitle:(NSString *)title;
@end
