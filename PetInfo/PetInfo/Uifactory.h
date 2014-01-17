//
//  Uifactory.h
//  东北新闻网
//
//  Created by 佐筱猪 on 13-12-22.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NightModelLabel.h"
#import "FontLabel.h"
#import "NightModelUIButton.h"
#import "NightModelScrollView.h"
#import "NightModelTextView.h"
@interface Uifactory : NSObject

//创建Label 不改变字体大小的label
+ (NightModelLabel *)createLabel:(NSString *)colorName ;
//创建Label 改变字体大小的label 即正文label
+ (FontLabel *)createLabel:(NSString *)colorName sizeFont :(int)sizeFont;
//创建button，改变字体和背景颜色
+ (NightModelUIButton *)createButton:(NSString *)titleName;
//创建scrollview，改变背景颜色
+ (NightModelScrollView *)createScrollView ;
//创建textview，改变字体大小及背景颜色
+ (NightModelTextView *)createTextView;
@end
