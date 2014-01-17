//
//  NightModelTextView.m
//  东北新闻网
//
//  Created by tenyea on 14-1-11.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "NightModelTextView.h"
#import "ThemeManager.h"

@implementation NightModelTextView

-(id)init{
    self = [super init];
    if (self) {
//        字体颜色通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
        [self setTextSize];
        [self setColor];
    }
    return  self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

//设置颜色
-(void)NightModeChangeNotification:(NSNotification *)notification{
    [self setColor];
}
-(void)setColor{
    UIColor *textColor = [[ThemeManager shareInstance] getColorWithName:ktext];
    self.textColor = textColor;
    self.backgroundColor = [[ThemeManager shareInstance] getBackgroundColor];
}

//设置字体大小
-(void)setTextSize{
    int mulriple = [[ThemeManager shareInstance]getSizeFont];
    float mul = 0.0f;
    switch (mulriple) {
        case 0:
            mul = 12.0f;
            break;
        case 1:
            mul = 16.0f;
            break;
        case 2:
            mul = 20.0f;
            break;
        default:
            mul = 16.0f;
            break;
    }
    self.font = [UIFont systemFontOfSize:mul];
}


@end
