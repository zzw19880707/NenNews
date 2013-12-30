//
//  FontLabel.h
//  东北新闻网
//  此类为衍生类， 增加字体大小修改
//  Created by tenyea on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "NightModelLabel.h"

@interface FontLabel : NightModelLabel

@property (nonatomic,assign) int sizeFont;

- (id)initWithColorName:(NSString *)colorName sizeFont:(int)sizeFont;

@end
