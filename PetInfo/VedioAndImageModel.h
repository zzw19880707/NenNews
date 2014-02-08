//
//  VedioAndImageModel.h
//  东北新闻网
//
//  Created by tenyea on 14-2-8.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "BaseModel.h"

@interface VedioAndImageModel : BaseModel

@property (nonatomic,copy) NSString *newsId;//标题id
@property (nonatomic,copy) NSString *videoUrl;//地址
@property (nonatomic,copy) NSString *videoPic;//图片地址
@property (nonatomic,copy) NSString *videoTitle;//标题

@end
