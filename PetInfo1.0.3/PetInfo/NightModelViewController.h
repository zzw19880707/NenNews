//
//  NightModelViewController.h
//  东北新闻网
//
//  Created by tenyea on 14-1-3.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "BaseViewController.h"
@class FMDatabase;
@interface NightModelViewController : BaseViewController{
    NSMutableDictionary *_collectionDic;
}

@property (nonatomic,retain) NSString *newsId;
@property (nonatomic,retain) NSString *titleLabel;
//用于分享的链接
@property (nonatomic,retain) NSString *url;
//用于分享的图片地址
@property (nonatomic,retain) NSString *ImageUrl;

@property (nonatomic,retain) NSString *newsAbstract;
//0普通新闻1专题新闻2图片新闻3视频新闻
@property (nonatomic,assign) int type;

@end
