//
//  NightModelContentViewController.h
//  东北新闻网
//
//  Created by 佐筱猪 on 14-1-1.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "NightModelViewController.h"

@interface NightModelContentViewController : NightModelViewController <UIAlertViewDelegate>{
    NSMutableArray *_imageArray;//图片数组
    NSArray *_contentArray;//内容数组
    NSString *_comAddress;//来源
    NSString *_createtime;//创建时间
    NSArray *_abnewsArray;//摘要数组
}
@property (nonatomic,retain) NSString *content;

@end
