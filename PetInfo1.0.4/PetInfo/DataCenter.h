//
//  DataCenter.h
//  东北新闻网
//
//  Created by tenyea on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCenter : NSObject


+ (DataCenter*)sharedCenter;
//获取cache大小
- (NSUInteger)cacheSize;
//- (void)cacheData;
//清空缓存
- (void)cleanCache;
//按照目录删除文件
+(void) deleteAllFilesInDir:(NSString*)path;
//获取路径下文件大小
+(float)fileSizeForDir:(NSString*)path;
//获取显示/隐藏的栏目
+(NSArray *)getShowColumn:(int)show andSubscribe:(BOOL)issubscribe;

//比如说有当前文章的发表时间，那么theDate就是这个时间，然后这个方法返回的字符串就是你需要的时间，几分钟前，或者几小时前，具体的需求再重新修改就可以了
+ (NSString*)intervalSinceNow: (NSString*) theDate;
//nsstring 与nsdate 互转
+(NSString *)dateTOString :(NSDate *)date ;
+(NSDate *)StringTODate :(NSString *)strDate;

//判断当前网络环境
+(NSString *) getConnectionAvailable;
//判断当前是否有网络
+(BOOL) isConnectionAvailable;
@end
