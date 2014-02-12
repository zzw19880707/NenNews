//
//  NightModelLabel.h
//  东北新闻网
//  用于更改夜间模式和字体大小
//  Created by 佐筱猪 on 13-12-22.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NightModelLabel : UILabel


@property (nonatomic,copy) NSString *colorName;

@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,assign) BOOL isTitle;

- (id)initWithColorName:(NSString *)colorName ;

//- (id)initWithNewsId:(NSString *)newsId;
//@property (nonatomic,retain) NSString *newsId;
@end
