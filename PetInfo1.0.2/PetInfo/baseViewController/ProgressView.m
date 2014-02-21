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
#import "ASIDownloadCache.h"
#import "ColumnModel.h"
@implementation ProgressView

-(id)init{
    self = [super init];
    if (self!=nil) {
        //kReachabilityChangedNotification 网络状态改变时触发的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNetwork:) name:kReachabilityChangedNotification object:nil];
        self.reachability = [Reachability reachabilityForInternetConnection];
        //开始监听网络
        [self.reachability startNotifier];
        
        NetworkStatus status = self.reachability.currentReachabilityStatus;
        [self checkNetWork:status];
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        if (!_queue) {
            _queue = [[ASINetworkQueue alloc]init];
        }
    }
    return self;
}

-(id)initWithPath:(NSString *)path{
    self = [self init];
    if (self!=nil) {
//        self.reachability = [Reachability reachabilityForInternetConnection];
//        //开始监听网络
//        [self.reachability startNotifier];
//        
//        NetworkStatus status = self.reachability.currentReachabilityStatus;
//        [self checkNetWork:status];
//        self.path = path;
//        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [UIApplication sharedApplication].statusBarHidden=YES;
    //---------------------ASI下载--------------------
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView =
    [[ADVPercentProgressBar alloc] initWithFrame:CGRectMake(-4 , -5, ScreenWidth -20, 28)
                             andProgressBarColor:ADVProgressBarBlue];
    
    [_progressView setMinProgressValue:0];
    [_progressView setMaxProgressValue:100];


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

    
    // 使得每一次下载都是重新来过的
    [_queue reset];
//    NSArray *array = @[@"http://192.168.1.145:8080/nen/getNewscontent?titleId=011759708",@"http://192.168.1.145:8080/nen/getNewscontent?titleId=011759707"];
    
    //栏目数组
    NSMutableArray *nameArrays = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:show_column]];
    int count = [[NSUserDefaults standardUserDefaults]integerForKey:kpageCount];
    for (int i = 0 ; i < nameArrays.count ; i++) {
        NSDictionary *dic = nameArrays[i];
        NSString *url =  [NSString stringWithFormat:@"%@getColumnList?count=%d&columnID=%@",BASE_URL,(count+1)*10,[dic objectForKey:@"columnId"]];
        _po(url);
        ASIHTTPRequest *columnrequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        [columnrequest setCompletionBlock:^{
//            更新最后更新时间
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSDictionary *columnDIC = @{@"lastDate":[NSDate date]};
            [userDefault setValue:columnDIC forKey:[NSString stringWithFormat:@"columnid=%@",[dic objectForKey:@"columnId"]]];
            [userDefault synchronize];
//获取数据源
            NSData *data = columnrequest.responseData;
            id result = nil ;
            result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = [result objectForKey:@"data"];
            for (NSDictionary *dic in array) {
                ColumnModel *model = [[ColumnModel alloc]initWithDataDic:dic ];
                NSString *str = [NSString stringWithFormat:@"%@getNewscontent?titleId=%@",BASE_URL,model.newsId];
                _path = str;
                _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_path]];
                ASIDownloadCache *cache = [[ASIDownloadCache alloc]init];//创建缓存对象
                NSString *cachePath = [FileUrl getCacheFileURL]; //设置缓存目录
                DLOG(@"cachepath:%@",cachePath);
                [cache setStoragePath:cachePath];
                cache.defaultCachePolicy =ASIUseDefaultCachePolicy; //设置缓存策略
                _request.cacheStoragePolicy =ASICachePermanentlyCacheStoragePolicy;
                _request.downloadCache = cache;
                [_queue addOperation:_request];
                
            }
            _queue.downloadProgressDelegate = progressView;
            // 设置queue完成后需要实现的UI方法，根据头文件里面定义，这个UI方法需要一个ASIHTTPRequest 的参数
            _queue.requestDidFinishSelector = @selector(queueDidFinish:);
            [_queue setRequestDidFailSelector:@selector(queueError:)];
            // 如果要实现SEL的方法则根据头文件定义需要把delegate定为self
            _queue.delegate = self;
            
            //    [_request startAsynchronous];
            [_queue go];
            
        }];
        [columnrequest startSynchronous];
    }
    
    
}

- (void)queueDidFinish:(ASIHTTPRequest *)request

{
    [self.eventDelegate finishDownload];
    
}
- (void)queueError:(ASIHTTPRequest *)request

{
    _po([[request error] localizedDescription]);
    [self.eventDelegate finishDownload];
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
