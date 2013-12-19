//
//  LeftViewController.h
//  东北新闻网
//
//  Created by 佐筱猪 on 13-12-18.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseViewController.h"

@interface LeftViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_imageArray ;
    NSArray *_nameArray ;
    UITableView *_tableView;
}
@property (nonatomic,retain) NSArray *imageArray ;
@property (nonatomic,retain) NSArray *nameArray ;



@end
