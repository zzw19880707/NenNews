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
//图片新闻分享通知
#define kImageShareNotification @"kImageShareNotification"
//推送通知
#define kPushNewsNotification @"kPushNewsNotification"
//图片浏览器返回通知
#define kImageReturnNofication @"kImageReturnNofication"

//夜间模式开启/关闭
#define kNightModeChangeNofication @"kNightModeChangeNofication"
#define kbackground @"background"
#define kselectText @"selectText"
#define ktext @"text"

//开始离线缓存
#define kofflineBeginNofication @"kofflineBeginNofication"

//字体大小改变
//#define kFontSizeChangeNofication @"kFontSizeChangeNofication"

#pragma mark DIC_KEY
#define kFont_Size @"kFontSize"
#define KNews_Push @"KNewsPUSH"
//打开模式
#define kBrownModelChangeNofication @"kBrownModelChangeNofication"

#pragma mark UserDefaults
//判断是否是夜间模式
#define kisNightModel @"isNightModel"
//判断是否是第一次登陆
#define kisNotFirstLogin @"isFirstLogin"
//百度推送绑定信息
#define BPushchannelid @"BPushchannelid"
#define BPushappid @"BPushappid"
#define BPushuserid @"BPushuserid"
//经纬度
#define kuser_longitude @"longitude"
#define kuser_latitude @"latitude"
//判断进入程序后是否定位
#define kisLocation @"isLocation"
//用户登陆后返回的id
#define kuser_id @"user_id"
#define kuser_name @"kuser_name"
#define kuser_password @"kuser_password"
#define kbroseMode @"BroseMode"
#define kpageCount @"pageCount"
//用户离线下载文件大小，用于断点续传
#define kdownloadContentSize @"kdownloadContentSize"
//用户当前位置编码,用于天气预报
#define kLocationCityCode @"kLocationCityCode"



//首页加载广告的大图
#define main_adImage_url @"main_adImage_url"
#pragma mark Nen_News_Color
#define NenNewsgroundColor COLOR(29, 32, 136)
#define NenNewsTextColor COLOR(247, 247, 247)


#pragma mark 文件名
#define column_show_file_name @"column_show.plist"
#define column_disshow_file_name @"column_disshow.plist"
#define data_file_name @"data.plist"
#define Night_file_name @"Night.plist"
#define NightModel_file_name @"NightModel.plist"
#define kSetting_file_name @"kNenSetting.plist"
#define kDownloadOffline_file_name @"offline.plist"
#define kDownloadCache_file_name @"cache.download"
#define kSearchHistory_file_name @"search_history.plist"
#define kCityWeatherCoder_file_name @"city.plist"
#define kCityCoder_file_name @"citycode.plist"
#define kCityindex_file_name @"cityindex.plist"
#define kWeatherData_file_name @"weatherData.plist"
#define kCollection_file_name @"collection.plist"

#endif
