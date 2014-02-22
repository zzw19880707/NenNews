//
//  BaseTableViewController.h
//  东北新闻网
//
//  Created by tenyea on 14-1-9.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import <CoreLocation/CoreLocation.h>
@class MBProgressHUD;
@interface BaseTableViewController : UITableViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate>{
    UIWindow *_tipWindow;
}
-(void)setStateBarHidden :(BOOL) statusBarHidden;

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

-(void)setTitle:(NSString *)title;
@end
