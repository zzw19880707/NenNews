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
@end
