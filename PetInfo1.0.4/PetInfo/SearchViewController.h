//
//  SearchViewController.h
//  东北新闻网
//
//  Created by tenyea on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseViewController.h"
@interface SearchViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,ASIRequest>{
    NSMutableArray *_searchHistoryData;
    NSArray *_searchData;
}
@property (retain, nonatomic) UITextField *searchBar;
@property (retain, nonatomic) UITableView *tableView;
@property (retain, nonatomic) NSArray *searchData;


@property (retain, nonatomic) UITableView *resultTableView;
@property (retain, nonatomic) NSArray *resultData;
@end
