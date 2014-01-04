//
//  ColumnModel.h
//  东北新闻网
//
//  Created by tenyea on 13-12-30.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseModel.h"

@interface ColumnModel : BaseModel

@property (nonatomic,retain) NSNumber *titleId;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *summary;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *titlePic;

@end
