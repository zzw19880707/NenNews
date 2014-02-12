//
//  BaseViewController+StatusBarStyle.h
//  东北新闻网
//
//  Created by tenyea on 13-12-18.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseViewController.h"


@interface StatusBarStyle : NSObject
+ (UIStatusBarStyle)statusBarStyle;
+ (BOOL)statusBarHidden;

@end

@interface BaseViewController (StatusBarStyle)

- (void)setStatusBarStyle:(UIStatusBarStyle)style;
- (void)setStatusBarHidden:(BOOL)isHidden;

@end
