//
//  Created by ShareSDK.cn on 13-1-14.
//  官网地址:http://www.ShareSDK.cn
//  技术支持邮箱:support@sharesdk.cn
//  官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
//  商务QQ:4006852216
//  Copyright (c) 2013年 ShareSDK.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSQZoneApp.h"
#import <ShareSDK/ShareSDKPlugin.h>

/**
 *	@brief	QQ空间连接器
 */
@interface QZoneConnection : NSObject <ISSPlatform>

/**
 *	@brief	创建应用配置信息
 *
 *	@param 	appKey 	应用标识
 *	@param 	appId 	应用密钥
 *
 *	@return	应用配置信息
 */
- (NSDictionary *)appInfoWithAppKey:(NSString *)appKey
                              appId:(NSString *)appId;

@end
