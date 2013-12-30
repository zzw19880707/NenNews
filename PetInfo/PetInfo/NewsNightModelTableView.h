//
//  NewsNightModelTableView.h
//  东北新闻网
//
//  Created by tenyea on 13-12-29.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseTableView.h"

@interface NewsNightModelTableView : BaseTableView

-(id)initwithColumnID:(int)columnID;

@property (nonatomic,assign) int columnID;
@property (nonatomic,copy) NSDate *lastDate;
@end
