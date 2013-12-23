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
@interface Uifactory : NSObject

//创建Label 不改变字体大小的label
+ (NightModelLabel *)createLabel:(NSString *)colorName ;
//创建Label 改变字体大小的label 即正文label
+ (FontLabel *)createLabel:(NSString *)colorName sizeFont :(int)sizeFont;
@end
