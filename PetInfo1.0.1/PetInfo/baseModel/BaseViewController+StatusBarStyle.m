//
//  BaseViewController+StatusBarStyle.m
//  东北新闻网
//
//  Created by tenyea on 13-12-18.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseViewController+StatusBarStyle.h"


@implementation StatusBarStyle
static UIStatusBarStyle statusBarStyle = UIStatusBarStyleDefault;
static bool isBarHidden = NO;
static BaseViewController *viewControllerv = nil;

+ (UIStatusBarStyle)statusBarStyle
{
    return statusBarStyle;
}

+ (BOOL)statusBarHidden
{
    return isBarHidden;
}

@end

@implementation UIViewController (StatusBarStyle)

- (void)setStatusBarStyle:(UIStatusBarStyle)style
{
    if (WXHLOSVersion()>=7.0) {
        statusBarStyle = style;
        [viewControllerv setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setStatusBarHidden:(BOOL)isHidden
{
    if (WXHLOSVersion()>=7.0) {
        isBarHidden = isHidden;
        [viewControllerv setNeedsStatusBarAppearanceUpdate];
    }
}

#ifdef __IPHONE_7_0

- (UIStatusBarStyle)preferredStatusBarStyle
{
    viewControllerv = nil;
    viewControllerv = self;
    return [StatusBarStyle statusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (BOOL)prefersStatusBarHidden
{
    return [StatusBarStyle statusBarHidden];
}
#endif
@end
