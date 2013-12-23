//
//  NightModelUIButton.m
//  东北新闻网
//
//  Created by 佐筱猪 on 13-12-22.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "NightModelUIButton.h"
#import "ThemeManager.h"
@implementation NightModelUIButton

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_titleName release];
//    [_backgroundHighligtImageName release];
//    [_backgroundHighligtImageName release];
//    [_highligtImageName release];
//    [_imageName release];
    [super dealloc];
    
}
- (id)initWithTitleName:(NSString *)titleName{
    self = [self init];
    if (self) {
        self.titleName =titleName;
    }
    return self;
}

//- (id)initWithImage:(NSString *)imageName highlighted:(NSString *)highligtImageName {
//    self = [self init];
//    if (self) {
//        self.imageName = imageName;
//        self.highligtImageName = highligtImageName;
//    }
//    return self;
//}
//
//- (id)initWithBackground:(NSString *)backgroundImageName
//   highlightedBackground:(NSString *)backgroundHighligtImageName {
//    self = [self init];
//    if (self) {
//        self.backgroundImageName = backgroundImageName;
//        self.backgroundHighligtImageName = backgroundHighligtImageName;
//    }
//    return self;
//}


-(id)init{
    self = [super init];
    if (self!=nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
    }
    return self;
}


#pragma mark - setter  设置图片名后，重新加载该图片名对应的图片
//- (void)setImageName:(NSString *)imageName {
//    if (_imageName != imageName) {
//        [_imageName release];
//        _imageName = [imageName copy];
//    }
//    //重新加载图片
//    [self loadColor];
//}
//
//- (void)setHighligtImageName:(NSString *)highligtImageName {
//    if (_highligtImageName != highligtImageName) {
//        [_highligtImageName release];
//        _highligtImageName = [highligtImageName copy];
//    }
//    
//    //重新加载图片
//    [self loadColor];
//}
//
//- (void)setBackgroundImageName:(NSString *)backgroundImageName {
//    if (_backgroundImageName != backgroundImageName) {
//        [_backgroundImageName release];
//        _backgroundImageName = [backgroundImageName copy];
//    }
//    
//    //重新加载图片
//    [self loadColor];
//}
//
//- (void)setBackgroundHighligtImageName:(NSString *)backgroundHighligtImageName {
//    if (_backgroundHighligtImageName != backgroundHighligtImageName) {
//        [_backgroundHighligtImageName release];
//        _backgroundHighligtImageName = [backgroundHighligtImageName copy];
//    }
//    
//    //重新加载图片
//    [self loadColor];
//}

//- (void)setLeftCapWidth:(int)leftCapWidth {
//    _leftCapWidth = leftCapWidth;
//    [self loadColor];
//}
-(void)setTitleName:(NSString *)titleName{
    if (_titleName !=titleName) {
        [_titleName release];
        _titleName = [titleName copy];
    }
    [self loadColor];
}


#pragma mark - NSNotification actions
- (void)NightModeChangeNotification:(NSNotification *)notification {
    //标题颜色，选中后标题颜色变为选中颜色，未选中为标题颜色
    [self loadColor];
}

-(void)loadColor {
    [self setTitle:_titleName forState:UIControlStateNormal];
    [self setTitleColor:[[ThemeManager shareInstance]getColorWithName:ktext] forState:UIControlStateNormal];
    [self setBackgroundColor:[[ThemeManager shareInstance] getBackgroundColor]];
}
@end
