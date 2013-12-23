//
//  NightModelLabel.m
//  东北新闻网
//
//  Created by 佐筱猪 on 13-12-22.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "NightModelLabel.h"
#import "ThemeManager.h"
@implementation NightModelLabel
- (void)dealloc {
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_colorName release];
}

- (id)initWithColorName:(NSString *)colorName {
    self = [self init];
    if (self != nil) {
        self.colorName = colorName;
        self.isSelect = NO;
//        self.isTitle =  isTitle;
//        //如果不是title，则设置字体颜色为选中的颜色
//        if (!_isTitle) {
//            self.colorName = @"selectText";
//        }
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self!=nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
    }
    return self;
}

- (void)setColorName:(NSString *)colorName {
    if (_colorName != colorName) {
        [_colorName release];
        _colorName = [colorName copy];
    }
    
    [self setColor];
}

-(void)setIsSelect:(BOOL)isSelect{
    if (_isSelect !=isSelect) {
        _isSelect = isSelect;
    }
    //选中时，更改调用的字体颜色
    _colorName = @"selectText";
    [self setColor];
}


- (void)setColor {
    UIColor *textColor = [[ThemeManager shareInstance] getColorWithName:_colorName];
    self.textColor = textColor;
}

#pragma mark - NSNotification actions
- (void)NightModeChangeNotification:(NSNotification *)notification {
    //标题颜色，选中后标题颜色变为选中颜色，未选中为标题颜色
    [self setColor];
    
    
}

@end
