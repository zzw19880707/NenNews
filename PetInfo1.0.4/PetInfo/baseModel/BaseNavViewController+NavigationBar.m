//
//  BaseNavViewController+NavigationBar.m
//  东北新闻网
//
//  Created by tenyea on 13-12-18.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseNavViewController+NavigationBar.h"

@implementation BaseNavViewController (NavigationBar)
- (void)setBarColor:(UIColor*)color
{
    if(WXHLOSVersion()>=7.0)
    {
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
        [self.navigationController.navigationBar setBarTintColor:color];
    }
    else
    {
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
        [self.navigationController.navigationBar setTintColor:color];
    }
}
@end
