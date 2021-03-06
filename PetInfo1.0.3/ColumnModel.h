//
//  ColumnModel.h
//  东北新闻网
//
//  Created by tenyea on 13-12-30.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseModel.h"

@interface ColumnModel : BaseModel

@property (nonatomic,copy) NSString *newsId;
@property (nonatomic,copy) NSNumber *type;
@property (nonatomic,copy) NSNumber *typeUp;//右上标(0:无 1：独家 2：原创 3：推荐)

@property (nonatomic,copy) NSString *newsAbstract;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *img1;//图片新闻
@property (nonatomic,copy) NSString *img2;//图片新闻
@property (nonatomic,copy) NSString *img3;//图片新闻

@property (nonatomic,assign) BOOL isselected;
@end
