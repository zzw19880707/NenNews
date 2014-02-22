//
//  NightModelScrollView.m
//  东北新闻网
//
//  Created by 佐筱猪 on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "NightModelScrollView.h"
#import "ThemeManager.h"
@implementation NightModelScrollView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self!=nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
        [self setBackgroundColor];
    }
    return self;
}

-(void)setBackgroundColor{
    self.backgroundColor = [[ThemeManager shareInstance]getBackgroundColor];
}

#pragma mark - NSNotification actions
- (void)NightModeChangeNotification:(NSNotification *)notification {
    //标题颜色，选中后标题颜色变为选中颜色，未选中为标题颜色
    [self setBackgroundColor];
    
}
@end
