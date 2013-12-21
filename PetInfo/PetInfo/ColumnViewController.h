//
//  ColumnViewController.h
//  东北新闻网
//
//  Created by tenyea on 13-12-21.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "LocationViewController.h"

@interface ColumnViewController : LocationViewController{
//    UIView *_showBackgroundView;
    
    UIView *_addBackgroundView;
    //所有栏目名
    NSArray *_columnNameArray;
    //显示的栏目
    NSMutableArray *_showNameArray;
    //不显示的栏目
    NSMutableArray *_addNameArray;
    //位置数组
    NSMutableArray *_LocationArray;
    //按钮移动到的位置
    CGRect _toFrame ;
    //判断视图是否改变
    BOOL _isviewchange;
}

@property (nonatomic,retain) NSMutableArray *showNameArray;
@property (nonatomic,retain) NSMutableArray *addNameArray;

@end
