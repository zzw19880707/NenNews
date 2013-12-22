//
//  kPetInfo.h
//  PetInfo
//
//  Created by 佐筱猪 on 13-11-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#ifndef PetInfo_kPetInfo_h
#define PetInfo_kPetInfo_h

#pragma mark NSNotificationCenter
//夜间模式开启/关闭
#define kNightModeChangeNofication @"kNightModeChangeNofication"
//字体大小改变
#define kFontSizeChangeNofication @"kFontSizeChangeNofication"
#define kSizeBigNofication @"20"
#define kSizeMiddleNofication @"20"
#define kSizeSmallNofication @"20"

#pragma mark UserDefaults
//判断是否是第一次登陆
#define isNotFirstLogin @"isFirstLogin"
//百度推送绑定信息
#define BPushchannelid @"BPushchannelid"
#define BPushappid @"BPushappid"
#define BPushuserid @"BPushuserid"
//经纬度
#define user_longitude @"longitude"
#define user_latitude @"latitude"
//判断进入程序后是否定位
#define isLocation @"isLocation"
//用户登陆后返回的id
#define user_id @"user_id"
//首页加载广告的大图
#define main_adImage_url @"main_adImage_url"
#pragma mark Nen_News_Color
#define NenNewsTextColor COLOR(88, 195, 241)
#define NenNewsgroundColor COLOR(247, 247, 247)


#pragma mark 文件名
#define column_file_name @"column.plist"
#define data_file_name @"data.plist"
#define Night_file_name @"Night.plist"
#define NightModel_file_name @"NightModel.plist"
#endif
