//
//  ProgressView.m
//  东北新闻网
//
//  Created by tenyea on 13-12-24.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "ProgressView.h"
#import "ASIHTTPRequest.h"
#import "Reachability.h"
#import "DataCenter.h"
#import "FileUrl.h"
#import "ADVPercentProgressBar.h"
@implementation ProgressView

-(id)init{
    self = [super init];
    if (self!=nil) {
        //kReachabilityChangedNotification 网络状态改变时触发的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNetwork:) name:kReachabilityChangedNotification object:nil];
    }
    return self;
}

-(id)initWithPath:(NSString *)path{
    self = [self init];
    if (self!=nil) {
        self.reachability = [Reachability reachabilityForInternetConnection];
        //开始监听网络
        [self.reachability startNotifier];
        
        NetworkStatus status = self.reachability.currentReachabilityStatus;
        [self checkNetWork:status];
        self.path = path;
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
//    NSUserDefaults *userDefaluts =[NSUserDefaults standardUserDefaults];
    [UIApplication sharedApplication].statusBarHidden=YES;
    //---------------------ASI下载--------------------
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView =
    [[ADVPercentProgressBar alloc] initWithFrame:CGRectMake(-4 , -5, ScreenWidth -20, 28)
                             andProgressBarColor:ADVProgressBarBlue];
    
    [_progressView setMinProgressValue:0];
    [_progressView setMaxProgressValue:100];

//    float totleSize = [[userDefaluts objectForKey:kdownloadContentSize] intValue];
//    NSString *temPath = NSTemporaryDirectory();
//    float lastprogress =[DataCenter fileSizeForDir:temPath];
//    _pf(lastprogress/totleSize*100.0f);
//    if (lastprogress!=0) {
//        [_progressView setProgress: [_progressView minProgressValue]+lastprogress/totleSize*100.0f];
//    }
    [self addSubview:_progressView];
    
    
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"progress_button_cencel.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(ScreenWidth-25, 0 , 25, 20);
    [button addTarget:self action:@selector(cencelAction) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    [self addSubview:button];
    [button release];
    
    //通过kvo监听progress值，达到监听进度的目的
    [progressView addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
    
    

    NSString *path = [[FileUrl getDocumentsFile] stringByAppendingPathComponent:kDownloadOffline_file_name];
    
    _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_path]];
    [_request setHeadersReceivedBlock:^(NSDictionary *responseHeaders){
        //响应头
        //        NSDictionary *responseHeaders = request.responseHeaders;
        NSLog(@"%@",responseHeaders);
        
        //获取下载文件大小
        NSNumber *contentSize = [responseHeaders objectForKey:@"Content-Length"];
//        [userDefaluts setValue:contentSize forKey:kdownloadContentSize];
//        [userDefaluts synchronize];
        
    }];
    
    //设置文件下载存放的路径
    [_request setDownloadDestinationPath:path];
    //设置进度条
    _request.downloadProgressDelegate = progressView;
    
    //------------------------断点续传-----------------------
    //设置是否支持断点续传
    [_request setAllowResumeForFileDownloads:YES];
    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingString:kDownloadCache_file_name];
    //设置下载过程中暂存的文件路径
    [_request setTemporaryFileDownloadPath:tempPath];
    [_request startAsynchronous];

}
#pragma mark Action
-(void)cencelAction{
    [_request clearDelegatesAndCancel];
    [self.eventDelegate finishDownload];

}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
//    NSLog(@"%@",change);
    NSNumber *value = [change objectForKey:@"new"];
    float progress = [value floatValue];
    NSLog(@"%.1f%%",progress*100);
    
    [_progressView setProgress:[_progressView minProgressValue] +
     ([_progressView maxProgressValue] -
      [_progressView minProgressValue]) * progress
     ];

    
    int pro = progress*100;
    if (pro ==100) {
        [self.eventDelegate finishDownload];
    }
}


//网络状态改变的时候调用
- (void)changeNetwork:(NSNotification *)notification {
    NetworkStatus status = self.reachability.currentReachabilityStatus;
    [self checkNetWork:status];
}



- (void)checkNetWork:(NetworkStatus)status {
    if (status == kNotReachable) {
        NSLog(@"没有网络");
    }
    else if(status == kReachableViaWWAN) {
        NSLog(@"3G/2G");
    }
    else if(status == kReachableViaWiFi) {
        NSLog(@"WIFI");
    }
}
@end
