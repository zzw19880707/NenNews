//
//  ThemeManager.h
//  东北新闻网
//
//  Created by 佐筱猪 on 13-12-22.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManager : NSObject

//配置夜间模式的plist文件
@property(nonatomic,retain)NSDictionary *nigthModelPlist;


//Label字体颜色配置plist文件
@property(nonatomic,retain)NSDictionary *fontColorPlist;

//当前使用的模式    日间|夜间
@property(nonatomic,retain)NSString *nigthModelName;

//当前使用的字体大小、推送设置 setting配置文件
@property (nonatomic,retain)NSDictionary *settingPlist;
+ (ThemeManager *)shareInstance;



//返回当前模式下，字体的颜色
- (UIColor *)getColorWithName:(NSString *)name;
//返回当前模式下，背景的颜色
-(UIColor *)getBackgroundColor;
//返回当前模式下，字体的大小
- (int)getSizeFont;
//返回打开模式
-(int)getBroseModel;
//设置推送开启关闭
- (void)setPush;
@end
