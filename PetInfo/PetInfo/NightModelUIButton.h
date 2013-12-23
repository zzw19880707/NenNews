//
//  NightModelUIButton.h
//  东北新闻网
//
//  Created by 佐筱猪 on 13-12-22.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NightModelUIButton : UIButton


//标题
@property (nonatomic,copy) NSString *titleName;

////Normal状态下的图片名称
//@property(nonatomic,copy)NSString *imageName;
////高亮状态下的图片名称
//@property(nonatomic,copy)NSString *highligtImageName;
//
////Normal状态下的背景图片名称
//@property(nonatomic,copy)NSString *backgroundImageName;
////高亮状态下的背景图片名称
//@property(nonatomic,copy)NSString *backgroundHighligtImageName;
//
////图片拉伸
//@property(nonatomic,assign)int leftCapWidth;
//@property(nonatomic,assign)int topCapHeight;
//
//- (id)initWithImage:(NSString *)imageName highlighted:(NSString *)highligtImageName;
//
//- (id)initWithBackground:(NSString *)backgroundImageName
//   highlightedBackground:(NSString *)backgroundHighligtImageName;

- (id)initWithTitleName:(NSString *)titleName;
@end
