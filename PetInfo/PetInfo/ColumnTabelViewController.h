//
//  ColumnTabelViewController.h
//  东北新闻网
//
//  Created by tenyea on 13-12-24.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//
@protocol ColumnChangedDelegate  <NSObject>

-(void)columnChanged:(NSArray *)array;

@end
#import <UIKit/UIKit.h>
@interface ColumnTabelViewController : UITableViewController
{

    //显示的栏目
    NSMutableArray *_showNameArray;
    //不显示的栏目
    NSMutableArray *_addNameArray;

}
@property (nonatomic ,assign) id<ColumnChangedDelegate> eventDelegate;
@end
