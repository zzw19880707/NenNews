//
//  DataCenter.m
//  东北新闻网
//
//  Created by tenyea on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "DataCenter.h"
#import "FileUrl.h"
static DataCenter *sigleton = nil;
@implementation DataCenter

//获取cache大小
- (NSUInteger)cacheSize{
        float size = [DataCenter fileSizeForDir:[FileUrl getCacheFile]];
    return size;
}

//获取路径下文件大小
+(float)fileSizeForDir:(NSString*)path//计算文件夹下文件的总大小
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float size =0;
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        //判断是否是文件夹
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            size+= fileAttributeDic.fileSize;
        }
        else
        {
            size+=[self fileSizeForDir:fullPath];
        }
    }
    [fileManager release];
    return size;
}
//- (void)cacheData;
//清空缓存
- (void)cleanCache{
    NSString *cachesDir = [FileUrl getCacheFile];
    [DataCenter deleteAllFilesInDir:cachesDir];
}
//按照目录删除文件
+(void) deleteAllFilesInDir:(NSString*)path {
	NSError* err=nil;

    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        //判断是否是文件夹
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            [fileManager removeItemAtPath:fullPath error:&err];
        }
        else
        {
            [self deleteAllFilesInDir:fullPath];
        }
    }
    [fileManager release];
}







//获取显示的栏目
+(NSArray *)getShowColumn:(int)show andSubscribe:(BOOL)issubscribe{
    FMDatabase *db = [FileUrl getDB];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    NSLog(@"%@",[NSString stringWithFormat:@"select * from columnList where isshow = %d and takepart = %d",show,(issubscribe?1:0)]);
    //                    更新userdefaults中的显示栏目
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from columnList where isshow = %d and takepart = %d",show,(issubscribe?1:0)]];
    NSMutableArray *showcolumn = [[NSMutableArray alloc]init];
    while (rs.next) {
        NSString *appPartName = [rs stringForColumn:@"columnName"];
        NSString *columnId = [NSString stringWithFormat:@"%d",[rs intForColumn:@"column"]];
        NSString *showimage = [NSString stringWithFormat:@"%d",[rs intForColumn:@"isImage"]];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[appPartName,columnId,showimage] forKeys:@[@"name",@"columnId",@"showimage"]];
        [showcolumn addObject:dic];
        [dic release];
    }
    return showcolumn;

}


















//实例化
+(DataCenter *)sharedCenter{
    
    if (sigleton == nil) {
        @synchronized(self){
            sigleton = [[DataCenter alloc] init];
        }
    }
    return sigleton;

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
