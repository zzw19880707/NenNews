//
//  SubscribeViewController.h
//  东北新闻网
//  订阅新闻
//  Created by tenyea on 14-2-8.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseScrollView.h"
#import "VedioNightModelView.h"
#import "ColumnTabelViewController.h"

@interface SubscribeViewController : BaseViewController <UItableviewEventDelegate,VedioNightModelViewDelegate,UIScrollViewEventDelegate,ColumnChangedDelegate>{
    BaseScrollView *_sc;
}
@property (nonatomic ,assign) BOOL isLoading;

@end
