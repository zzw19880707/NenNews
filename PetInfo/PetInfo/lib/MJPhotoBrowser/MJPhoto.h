//
//  MJPhoto.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <Foundation/Foundation.h>

@interface MJPhoto : NSObject
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *image; // 完整的图片

@property (nonatomic, strong) UIImageView *srcImageView; // 来源view
@property (nonatomic, strong, readonly) UIImage *placeholder;
@property (nonatomic, strong, readonly) UIImage *capture;

@property (nonatomic, assign) BOOL firstShow;


@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, strong) NSString *content;//内容
// 是否已经保存到相册
@property (nonatomic, assign) BOOL save;
@property (nonatomic, assign) int index; // 索引
@end