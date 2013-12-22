//
//  Uifactory.h
//  东北新闻网
//
//  Created by 佐筱猪 on 13-12-22.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NightModelLabel.h"

@interface Uifactory : UIImage

//创建Label
+ (NightModelLabel *)createLabel:(NSString *)colorName  sizeName:(NSString *)sizeName;
@end
