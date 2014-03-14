//
//  AppDelegate.m
//  PetInfo
//
//  Created by 佐筱猪 on 13-11-16.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "FileUrl.h"
#import <RennSDK/RennSDK.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "WeiboApi.h"
@implementation AppDelegate
@synthesize pushModel = _pushModel;
#pragma mark 内存管理
- (void)dealloc
{
    [_window release];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}
-(void)shareSDK{
    [ShareSDK registerApp:@"12446798b956"];
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"1013662903"
                               appSecret:@"4279d2d491e22911018abd8dff9e7d57"
                             redirectUri:@"http://www.sharesdk.cn" weiboSDKCls:[WeiboSDK class]] ;
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801480021"
                                  appSecret:@"1d7424cfb76f8c2b5719ad4aaf88dd4b"
                                redirectUri:@"http://www.sharesdk.cn"
                                   wbApiCls:[WeiboApi class]];
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"101019244"
                           appSecret:@"284d2fcd638a76bfb7802eedb73fe852"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wx6b665e9bc0f77e41" wechatCls:[WXApi class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];

    [ShareSDK connectQQWithQZoneAppKey:@"101019244"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];

    
    /**
     连接人人网应用以使用相关功能，此应用需要引用RenRenConnection.framework
     http://dev.renren.com上注册人人网开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectRenRenWithAppId:@"246289"
                              appKey:@"ec7163b7094d404eb4bddfa1803681fe"
                           appSecret:@"655df8b512f94a6f961b448da5ce119d"
                   renrenClientClass:[RennClient class]];
}
-(void)pushmodel{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey: kServletPush_Model];
    ColumnModel *model = [[ColumnModel alloc]init];
    model.newsId = [dic objectForKey:@"newsId"];
    model.title = [dic objectForKey:@"title"];
    model.newsAbstract = [dic objectForKey:@"newsAbstract"];
    model.type = [dic objectForKey:@"type"];
    model.img = [dic objectForKey:@"img"];
    model.isselected = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:kPushNewsNotification object: model];
}
#pragma mark 入口
//程序入口
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self shareSDK];
    if (launchOptions !=nil) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSString *alertString = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        NSString *newsId = [userInfo objectForKey:@"newsId"];
        if (newsId) {
            NSDictionary *dic = @{@"newsId":newsId,
                                  @"title": alertString,
                                  @"newsAbstract":[userInfo objectForKey:@"newsAbstract"],
                                  @"type":[userInfo objectForKey:@"type"],
                                  @"img":[userInfo objectForKey:@"img"]==nil?@"":[userInfo objectForKey:@"img"]
                                  };
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            [userdefaults setObject:dic forKey: kServletPush_Model ];
            [userdefaults synchronize];
            [self performSelector:@selector(pushmodel) withObject:nil afterDelay:6];
        }

    }
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    //初始化MainViewController
    _mainCtrl = [[MainViewController alloc] init];
    self.window.rootViewController=_mainCtrl;
    [self.window makeKeyAndVisible];
    //设置百度推送代理
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    //设置角标为0
    [application setApplicationIconBadgeNumber:0];
    
//已经使用过的用户
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kbundleVersion]) {
        
        //设置文件初始化
        NSString *settingPath = [[FileUrl getDocumentsFile] stringByAppendingPathComponent: kSetting_file_name];
        [[NSFileManager defaultManager] createFileAtPath: settingPath contents: nil attributes: nil];
        //设置文件信息
        NSMutableDictionary *settingDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt: 1], kFont_Size, [NSNumber numberWithBool: YES], KNews_Push, nil];
        [settingDic writeToFile: settingPath atomically: YES];
    }
    // 注册通知（声音、标记、弹出窗口）
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert
     | UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeSound];
    _pushModel = [[ColumnModel alloc]init];

    return YES;
}
//注册token
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [BPush registerDeviceToken: deviceToken];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:BPushappid] ==nil||[[[NSUserDefaults standardUserDefaults]objectForKey:BPushappid]isEqualToString:@""]) {
        //绑定
        [BPush bindChannel];
    }
    _po(deviceToken);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    NSLog(@"Receive Notify: %@", [userInfo JSONString]);
    NSString *alertString = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        NSString *newsId = [userInfo objectForKey:@"newsId"];
        if (newsId) {
            // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送新闻:"
                                                                message:[NSString stringWithFormat:@"%@", alertString]
                                                               delegate:self
                                                      cancelButtonTitle:@"好的"
                                                      otherButtonTitles:@"查看",nil];
            ColumnModel *model = [[ColumnModel alloc]init];
            model.newsId = newsId;
            model.title = alertString;
            model.newsAbstract = [userInfo objectForKey:@"newsAbstract"];
            model.type = [userInfo objectForKey:@"type"];
            model.img = [userInfo objectForKey:@"img"];
            model.isselected = NO;
            _pushModel = model;
            [alertView show];
        }else{
            // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送新闻:"
                                                                message:[NSString stringWithFormat:@"%@", alertString]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];

        }
    }else if (application.applicationState == UIApplicationStateInactive){//进入激活状态  默认查看新闻
        NSString *newsId = [userInfo objectForKey:@"newsId"];
        if (newsId) {
            ColumnModel *model = [[ColumnModel alloc]init];
            model.newsId = newsId;
            model.title = alertString;
            model.newsAbstract = [userInfo objectForKey:@"newsAbstract"];
            model.type = [userInfo objectForKey:@"type"];
            model.img = [userInfo objectForKey:@"img"];
            model.isselected = NO;
            _pushModel = model;
            [[NSNotificationCenter defaultCenter]postNotificationName:kPushNewsNotification object:_pushModel];
        }

    }
    [application setApplicationIconBadgeNumber:0];
    [BPush handleNotification:userInfo];

}
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //设置角标为0
    [application setApplicationIconBadgeNumber:0];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

//检查是否已加入handleOpenURL的处理方法
- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
#pragma mark pushdelegate  回调函数
- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethod_Bind isEqualToString:method]) {//绑定
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == BPushErrorCode_Success) {
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            [user setValue:appid forKey:BPushappid];
            [user setValue:userid forKey:BPushuserid];
            [user setValue:channelid forKey:BPushchannelid];
            //同步
            [user synchronize];
            
        }
    } else if ([BPushRequestMethod_Unbind isEqualToString:method]) {//解除绑定
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == BPushErrorCode_Success) {
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            [user removeObjectForKey:BPushchannelid];
            [user removeObjectForKey:BPushuserid];
            [user removeObjectForKey:BPushappid];
            //同步
            [user synchronize];
        }
    }

}
#pragma mark uialertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:kPushNewsNotification object:_pushModel];
    }
}
@end
