//
//  DataCenter.m
//  东北新闻网
//
//  Created by tenyea on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "DataCenter.h"
#import "FileUrl.h"
#import "Reachability.h"
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
    //                    更新userdefaults中的显示栏目
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from columnList where hidden = 1 and isshow = %d and takepart = %d",show,(issubscribe?1:0)]];
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


+(NSString *)dateTOString :(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return strDate;
}
+(NSDate *)StringTODate :(NSString *)strDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:strDate];
    [dateFormatter release];
    return date;
}
+ (NSString*)intervalSinceNow: (NSString*) theDate
{
    NSDateFormatter*date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate*d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString*timeString=@"";
    NSTimeInterval cha=now-late;
    //发表在一小时之内
    if(cha/3600<1) {
        if(cha/60<1) {
            timeString = @"刚刚";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];

        }
        
    }
    //在一小时以上24小以内
    else if(cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    //发表在24以上10天以内
    else if(cha/86400>1&&cha/864000<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    //发表时间大于10天
    else
    {
        //        timeString = [NSString stringWithFormat:@"%d-%"]
        NSArray*array = [theDate componentsSeparatedByString:@" "];
        //        return [array objectAtIndex:0];
        timeString = [array objectAtIndex:0];
        timeString = [timeString substringWithRange:NSMakeRange(5, [timeString length]-5)];
    }
    return timeString;
}




//判断当前是否有网络
+(NSString *) getConnectionAvailable{
    NSString *isExistenceNetwork = @"none";
    Reachability *reach = [Reachability reachabilityWithHostName:BASE_URL];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = @"none";
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = @"wifi";
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = @"3g";
            //NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
}

//判断当前是否有网络
+(BOOL) isConnectionAvailable{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:BASE_URL];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
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
