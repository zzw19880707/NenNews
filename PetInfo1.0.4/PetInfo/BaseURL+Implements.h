//
//  BaseURL+Implements.h
//  PetInfo
//
//  Created by 佐筱猪 on 13-11-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#ifndef PetInfo_BaseURL_Implements_h
#define PetInfo_BaseURL_Implements_h
//#define BASE_URL @"http://192.168.1.126:8080/nen/"
#define BASE_URL @"http://192.168.1.145:8090/nen/"
//#define BASE_URL @"http://app.nen.com.cn/"

//获取普通新闻内容及视频新闻
#define URL_getNews_content @"getNewscontent"
//获取图片新闻内容
#define URL_getImages_List @"getImagesList"
//获取专题新闻内容
#define URL_getThematic_List @"getThematicList"
//获取栏目下新闻列表
#define URL_getColumn_List @"getColumnList"
//获取推送新闻
#define URL_getPush_List @"PushHistoryServlet"
//获取首页大图
#define URL_AO @"Ao"
//获取订阅信息
#define URL_getsubscribe_List @"takePart"
//离线下载
#define URL_OffNews_List @"OffNewsList"
//传入查询内容 返回查询结果。 post请求
#define URL_Search @"SearchNews"

#pragma mark 天气预报
#define Weather_URL @"http://api.map.baidu.com/telematics/v3/weather?location="
#define Weather_Parms @"&output=json&ak=eSooGxlMfh26UVV8iIHiWjMa"
#define Weather_simple_URL @"http://www.weather.com.cn/data/cityinfo/"
#endif
