//
//  ColumnViewController.h
//  东北新闻网
//
//  Created by tenyea on 13-12-20.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseViewController.h"

@interface ColumnViewController : BaseViewController{
    UIView *_showBackgroundView;
    
    UIView *_addBackgroundView;
    //所有栏目名
    NSArray *_columnNameArray;
    //显示的栏目
    NSMutableArray *_showNameArray;
    //不显示的栏目
    NSMutableArray *_addNameArray;
    
}

@end
