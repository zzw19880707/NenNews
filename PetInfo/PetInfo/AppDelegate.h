//
//  AppDelegate.h
//  PetInfo
//
//  Created by 佐筱猪 on 13-11-16.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain) MainViewController *mainCtrl;
@end
