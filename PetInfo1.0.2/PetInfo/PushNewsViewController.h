//
//  PushNewsViewController.h
//  东北新闻网
//
//  Created by 佐筱猪 on 14-1-5.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "BaseViewController.h"
#import "NewsNightModelTableView.h"
@interface PushNewsViewController : BaseViewController <UItableviewEventDelegate>
@property (nonatomic ,assign) BOOL isLoading;

@end
