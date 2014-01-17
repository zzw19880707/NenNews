//
//  NewsContentModel.h
//  东北新闻网
//
//  Created by tenyea on 13-12-30.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseModel.h"

@interface NewsContentModel : BaseModel

@property (nonatomic,retain) NSNumber *newsId;//标题id
@property (nonatomic,copy) NSString *title;//标题
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *comeAddress;//来源
@property (nonatomic,copy) NSString *pubTime;//创建时间
@property (nonatomic,copy) NSString *content;//新闻内容
//@property (nonatomic,retain) NSArray *abnews;//相关新闻

@end
