//
//  UINavigationController+PushAnimated.m
//  东北新闻网
//
//  Created by tenyea on 13-12-28.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "UINavigationController+PushAnimated.h"

@implementation UINavigationController (PushAnimated)

//从左到右
- (void)customLeftToRightPushViewController:(UIViewController *)viewController
{
    viewController.view.frame = (CGRect){-viewController.view.frame.size.width, 0, viewController.view.frame.size};
    [self pushViewController:viewController animated:NO];
    [UIView animateWithDuration:1
                     animations:^{
                         viewController.view.frame = (CGRect){0, 0, self.view.bounds.size};
                     }];
}
@end
