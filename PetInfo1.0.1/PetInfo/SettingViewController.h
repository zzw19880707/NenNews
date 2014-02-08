//
//  SettingViewController.h
//  东北新闻网
//
//  Created by tenyea on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>{
    NSArray *_data;
    NSMutableDictionary *_settingDic;
}
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
