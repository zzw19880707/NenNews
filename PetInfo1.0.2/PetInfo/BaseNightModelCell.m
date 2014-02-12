//
//  BaseNightModelCell.m
//  东北新闻网
//
//  Created by tenyea on 14-1-26.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "BaseNightModelCell.h"
#import "ThemeManager.h"
#import "Reachability.h"
@implementation BaseNightModelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
        [self setcolor];

    }
    return self;
}

//判断当前是否有网络
-(NSString *) getConnectionAvailable{
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
#pragma mark - NSNotification actions
//夜间模式
-(void)NightModeChangeNotification:(NSNotification *)nsnotification{
    [self setcolor];
}
-(void)setcolor{
    self.backgroundColor = [[ThemeManager shareInstance]getBackgroundColor];
}
@end
