//
//  Uifactory.m
//  东北新闻网
//
//  Created by 佐筱猪 on 13-12-22.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "Uifactory.h"

@implementation Uifactory


//创建Label
+ (NightModelLabel *)createLabel:(NSString *)colorName  sizeName:(NSString *)sizeName{
    NightModelLabel *nightModelLabel = [[NightModelLabel alloc] initWithColorName:colorName sizeName:sizeName];
    
    return [nightModelLabel autorelease];
}
@end
