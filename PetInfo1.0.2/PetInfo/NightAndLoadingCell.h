//
//  NightAndLoadingCell.h
//  东北新闻网
//
//  Created by tenyea on 13-12-29.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNightModelCell.h"
@class NightModelLabel;
@class ColumnModel;
@interface NightAndLoadingCell : BaseNightModelCell{
    
    UIImageView *_imageView;
    NightModelLabel *_titleLabel;
    UILabel *_contentLabel;
    UILabel *_typeLabel;
    UILabel *_typeUpLabel;
//    图片视图
    UIImageView *_imageView1;
    UIImageView *_imageView2;
    UIImageView *_imageView3;
    NightModelLabel *_imageTitleLabel;


}

@property (nonatomic,retain) ColumnModel *model;

@property (nonatomic,retain) UILabel *titleLable;

- (id)initWithshoWImage:(BOOL)showImage type:(int)type ;
@property (nonatomic,assign) BOOL isselected;
@property (nonatomic,assign) BOOL showImage;
@property (nonatomic,assign) int type;
@end
