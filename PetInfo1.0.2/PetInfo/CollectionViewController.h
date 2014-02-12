//
//  CollectionViewController.h
//  东北新闻网
//
//  Created by 佐筱猪 on 14-1-5.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "BaseViewController.h"
#import "NewsNightModelTableView.h"

@interface CollectionViewController : BaseViewController <UItableviewEventDelegate>

@property (nonatomic,retain) NewsNightModelTableView *tableView;
@end
