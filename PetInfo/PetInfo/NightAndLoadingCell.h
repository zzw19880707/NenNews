//
//  NightAndLoadingCell.h
//  东北新闻网
//
//  Created by tenyea on 13-12-29.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ColumnModel;
@interface NightAndLoadingCell : UITableViewCell{
    
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
}

@property (nonatomic,retain) ColumnModel *model;

@property (nonatomic,retain) UILabel *titleLable;

@end
