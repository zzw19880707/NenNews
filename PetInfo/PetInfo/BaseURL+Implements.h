//
//  BaseURL+Implements.h
//  PetInfo
//
//  Created by 佐筱猪 on 13-11-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#ifndef PetInfo_BaseURL_Implements_h
#define PetInfo_BaseURL_Implements_h

#define BASE_URL @"http://192.168.1.145:8080/nen/"
//获取普通新闻内容
#define URL_getNews_content @"getNewscontent"
//获取图片新闻内容
#define URL_getImages_List @"getImagesList"
//获取专题新闻内容
#define URL_getThematic_List @"getThematicList"
//获取栏目下新闻列表
#define URL_getColumn_List @"getColumnList"



//传入查询内容 返回查询结果。 post请求
#define URL_Search @"search"

#pragma mark 天气预报
#define Weather_URL @"http://m.weather.com.cn/data/"

#endif
