//
//  NightModelContentViewController.h
//  东北新闻网
//
//  Created by 佐筱猪 on 14-1-1.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "NightModelViewController.h"

@interface NightModelContentViewController : NightModelViewController <UIAlertViewDelegate>{
    NSMutableArray *_imageArray;
    NSArray *_contentArray;
    NSString *_comAddress;
    NSString *_createtime;
}
@property (nonatomic,retain) NSString *content;

@end
