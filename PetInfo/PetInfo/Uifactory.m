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

//创建button，改变字体和背景颜色
+ (NightModelUIButton *)createButton:(NSString *)titleName{
    NightModelUIButton *nightButton =[[NightModelUIButton alloc]initWithTitleName:titleName];
    return [nightButton autorelease];
}

//创建scrollview，改变背景颜色
+ (NightModelScrollView *)createScrollView {
    NightModelScrollView *scrollView =[[NightModelScrollView alloc]init];
    return [scrollView autorelease];
}

//创建textview，改变字体大小及背景颜色
+ (NightModelTextView *)createTextView{
    NightModelTextView *textView = [[NightModelTextView alloc]init];
    return [textView autorelease];
}
@end
