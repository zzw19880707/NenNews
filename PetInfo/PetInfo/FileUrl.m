//
//  FileUrl.m
//  东北新闻网
//
//  Created by tenyea on 13-12-24.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "FileUrl.h"

@implementation FileUrl
//返回cache文件路径
+(NSString *)getCacheFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return cachesDir;
}
//返回cache缓存数据文件路径
+(NSString *)getCacheFileURL {
    return  [[self getCacheFile] stringByAppendingPathComponent:@"com.nen.news.data/"];
}
//返回document文件路径
+ (NSString *)getDocumentsFile {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    return plistPath1;
}
//返回数据库文件名
+ (NSString *)getDBFile{
    return  [[self getDocumentsFile] stringByAppendingPathComponent:@"NenNews.db"];
}
+ (FMDatabase *)getDB{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDBFile] ];
    return  db;
}
@end
