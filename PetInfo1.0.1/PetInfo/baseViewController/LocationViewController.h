//
//  LocationViewController.h
//  东北新闻网
//
//  Created by tenyea on 13-12-21.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LocationViewController : UIViewController
//返回appdelegate
-(AppDelegate *)appDelegate;
//取消按钮
@property (nonatomic,assign)BOOL isCancelButton;
@end
