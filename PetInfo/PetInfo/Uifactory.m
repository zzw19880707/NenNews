//
//  Uifactory.m
//  东北新闻网
//
//  Created by 佐筱猪 on 13-12-22.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "Uifactory.h"

@implementation Uifactory


//创建Label 不改变字体大小的label
+(NightModelLabel *)createLabel:(NSString *)colorName
{
    NightModelLabel *nightModelLabel = [[NightModelLabel alloc] initWithColorName:colorName ];
    
    return [nightModelLabel autorelease];
}


//创建Label 改变字体大小的label 即正文label
+(FontLabel *)createLabel:(NSString *)colorName sizeFont:(int)sizeFont
{
    FontLabel *fontLabel = [[FontLabel alloc] initWithColorName:colorName sizeFont:sizeFont];
    return [fontLabel autorelease];
}
@end
