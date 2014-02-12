//
//  RootViewController.h
//  东北新闻网
//
//  Created by tenyea on 13-12-19.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseScrollView.h"
#import "ColumnTabelViewController.h"
@interface RootViewController : BaseViewController <UIScrollViewEventDelegate,UIScrollViewDelegate,ColumnChangedDelegate,UItableviewEventDelegate,NewsNigthTabelViewDelegate>{
    BaseScrollView *_sc;
}

@end
