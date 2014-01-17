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
@property (nonatomic,copy) NSString *newsAbstract;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,assign) BOOL isselected;
@end
