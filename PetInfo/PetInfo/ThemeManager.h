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
+ (ThemeManager *)shareInstance;



//返回当前主题下，字体的颜色
- (UIColor *)getColorWithName:(NSString *)name;

@end
