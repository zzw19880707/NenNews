//
//  FontLabel.m
//  东北新闻网
//
//  Created by tenyea on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "FontLabel.h"
#import "ThemeManager.h"
@implementation FontLabel

- (void)dealloc {
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(id)init{
    self = [super init];
    if (self!=nil) {
        //字体改变通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FontSizeChangeNotification:) name:kFontSizeChangeNofication object:nil];
    }
    return self;
}
- (id)initWithColorName:(NSString *)colorName sizeFont:(int)sizeFont{
    self = [self init];
    if (self!=nil) {
        self.colorName =colorName;
        self.sizeFont = sizeFont;
    }
    return self;
}
-(void)setSizeFont:(int)sizeFont{
    if (_sizeFont !=sizeFont) {
        _sizeFont = sizeFont;
    }
    [self setSizeFont];
    
}
-(void)setSizeFont{
    int mulriple = [[ThemeManager shareInstance]getSizeFont];
    float mul = 0.0f;
    switch (mulriple) {
        case 0:
            mul = 0.7f;
            break;
        case 1:
            mul = 1.0f;
            break;
        case 2:
            mul = 1.3f;
            break;
        default:
            mul = 1.0f;
            break;
    }

    self.font = [UIFont systemFontOfSize:mul * _sizeFont];
}

-(void)FontSizeChangeNotification:(NSNotification *)notification{
    [self setSizeFont];
}
@end
