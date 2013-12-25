//
//  ProgressView.h
//  东北新闻网
//
//  Created by tenyea on 13-12-24.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ADVPercentProgressBar.h"
@class Reachability;
@protocol ProgressDelegate <NSObject>
//可选事件
@optional
-(void)finishDownload;

@end

@interface ProgressView : UIView{
    ADVPercentProgressBar *_progressView;
    ASIHTTPRequest *_request;
}
@property(nonatomic,retain)Reachability *reachability;
@property(nonatomic,retain) NSString *path;
@property(nonatomic,assign) id<ProgressDelegate> eventDelegate;
-(id)initWithPath:(NSString *)path;
@end
