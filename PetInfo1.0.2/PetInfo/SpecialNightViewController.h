//
//  SpecialNightViewController.h
//  东北新闻网
//  专题
//  Created by tenyea on 14-1-25.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableView.h"
@class SpecialNightModelTableView;
@interface SpecialNightViewController : BaseViewController<UItableviewEventDelegate>
@property (nonatomic,retain) NSString *newsId;

@property (nonatomic,retain) SpecialNightModelTableView *SpecialTableView;
@end
