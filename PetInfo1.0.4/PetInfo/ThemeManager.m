//
//  ThemeManager.m
//  东北新闻网
//
//  Created by 佐筱猪 on 13-12-22.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "ThemeManager.h"
#import "FileUrl.h"
@implementation ThemeManager
static ThemeManager *sigleton = nil;

+ (ThemeManager *)shareInstance {
    if (sigleton == nil) {
        @synchronized(self){
            sigleton = [[ThemeManager alloc] init];
        }
    }
    return sigleton;
}


- (id)init {
    self = [super init];
    if (self) {
        //读取主题配置文件
        NSString *themePath = [[NSBundle mainBundle] pathForResource:@"Night" ofType:@"plist"];
        self.nigthModelPlist = [NSDictionary dictionaryWithContentsOfFile:themePath];
        
        //默认为空
        self.nigthModelName = nil;
    }
    return self;
}

//返回打开模式
-(int)getBroseModel{
    int  brose = [[NSUserDefaults standardUserDefaults]integerForKey:kbroseMode];
    return brose;
}
//获取主题目录
- (NSString *)getThemePath {
    if (self.nigthModelName == nil) {
        //如果名字为空，则返回白天模式
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *dayPath = [resourcePath stringByAppendingPathComponent:@"NightMode/Day"];
        return  dayPath;
    }
    
    //取得夜间模式路径  例如NightMode/Day
    NSString *nightModelPath = [self.nigthModelPlist objectForKey:_nigthModelName];
    //程序包的根目录
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    //完整的主题包目录
    NSString *path = [resourcePath stringByAppendingPathComponent:nightModelPath];
    
    return path;
}

//切换模式时，会调用此方法，设置模式名称
-(void)setNigthModelName:(NSString *)nigthModelName{
    if (_nigthModelName != nigthModelName) {
        [_nigthModelName release];
        _nigthModelName = [nigthModelName copy];
    }
    
    //切换主题，重新加载当前主题下的字体配置文件
    NSString *themeDir = [self getThemePath];
    NSString *filePath = [themeDir stringByAppendingPathComponent:NightModel_file_name];
    self.fontColorPlist = [NSDictionary dictionaryWithContentsOfFile:filePath];

}
//返回当前模式下，背景的颜色

-(UIColor *)getBackgroundColor{
    //返回三色值，如：24,35,60
    NSString *rgb = [_fontColorPlist objectForKey:kbackground];
    NSArray *rgbs = [rgb componentsSeparatedByString:@","];
    if (rgbs.count == 3) {
        float r = [rgbs[0] floatValue];
        float g = [rgbs[1] floatValue];
        float b = [rgbs[2] floatValue];
        UIColor *color = COLOR(r, g, b);
        return color;
    }
    return nil;
}
//返回当前模式下，字体的颜色

- (UIColor *)getColorWithName:(NSString *)name {
    if (name.length == 0) {
        return nil;
    }
    //返回三色值，如：24,35,60
    NSString *rgb = [_fontColorPlist objectForKey:name];
    NSArray *rgbs = [rgb componentsSeparatedByString:@","];
    if (rgbs.count == 3) {
        float r = [rgbs[0] floatValue];
        float g = [rgbs[1] floatValue];
        float b = [rgbs[2] floatValue];
        UIColor *color = COLOR(r, g, b);
        return color;
    }
    return nil;
}

//获取setting文件路径
-(NSString *)getSettingPath {
    NSString *settingPath = [[FileUrl getDocumentsFile] stringByAppendingPathComponent: kSetting_file_name];
    _settingPlist =[[NSMutableDictionary alloc] initWithContentsOfFile: settingPath];
    return settingPath;
}
//获取字体大小
- (int)getSizeFont{
    [self getSettingPath];
    return [[_settingPlist objectForKey:kFont_Size]intValue] ;
}


//设置推送信息
-(void)setPush {
    [self getSettingPath];
    if ([[_settingPlist objectForKey:KNews_Push]boolValue]) {
        //注册
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert
         | UIRemoteNotificationTypeBadge
         | UIRemoteNotificationTypeSound];
    }else{
        //反注册
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }

}



//限制当前对象创建多实例
#pragma mark - sengleton setting
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sigleton == nil) {
            sigleton = [super allocWithZone:zone];
        }
    }
    return sigleton;
}

+ (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;
}

- (oneway void)release {
}

- (id)autorelease {
    return self;
}
@end
