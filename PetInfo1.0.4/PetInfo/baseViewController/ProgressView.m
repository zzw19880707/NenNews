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
#import "FileUrl.h"
#import "ADVPercentProgressBar.h"
#import "ASIDownloadCache.h"
#import "ColumnModel.h"


#import "UIImageView+WebCache.h"
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

    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [UIApplication sharedApplication].statusBarHidden=YES;
//    清楚缓存
    [[DataCenter sharedCenter]cleanCache];
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
    //栏目数组
    NSMutableArray *nameArrays = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:show_column]];
    int count = [[NSUserDefaults standardUserDefaults]integerForKey:kpageCount];
    NSMutableArray *names = [[NSMutableArray alloc]init];
    for (NSDictionary *modelDic  in nameArrays) {
        [names addObject: [modelDic objectForKey:@"columnId"]];
        [modelDic release];
    }
    NSString *partIds = [names componentsJoinedByString:@","];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:partIds forKey:@"partIds"];
    [parms setValue:[NSNumber numberWithInt:(count+1)*10] forKey:@"count"];
    [DataService requestWithURL:URL_OffNews_List andparams:parms andhttpMethod:@"GET" completeBlock:^(id result) {
        NSMutableArray *ImageArray = [[NSMutableArray alloc]init];
        //所有栏目
        NSArray *columnArray = [result objectForKey:@"alldata"];
        for (int i = 0 ; i < columnArray.count; i++) {
            NSDictionary *dic_model = columnArray [i];
            NSString *columnId = [dic_model objectForKey:@"columnId"];
            NSString *url_column = [NSString stringWithFormat:@"%@%@?count=%d&columnID=%@",BASE_URL,URL_getColumn_List,(count+1)*10,columnId];
//栏目重新访问
            
            _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url_column]];
            ASIDownloadCache *cache = [[ASIDownloadCache alloc]init];//创建缓存对象
            NSString *cachePath = [FileUrl getCacheFileURL]; //设置缓存目录
            [cache setStoragePath:cachePath];
            cache.defaultCachePolicy =ASIAskServerIfModifiedWhenStaleCachePolicy; //设置缓存策略
            _request.cacheStoragePolicy =ASICachePermanentlyCacheStoragePolicy;
            _request.downloadCache = cache;
            [_request setTimeOutSeconds:60*10];
            [_queue addOperation:_request];
            
//            data 数据
            NSArray *array = [dic_model objectForKey:@"data"];
            for (NSDictionary *dic in array) {
//                获取主图图片
                ColumnModel *model = [[ColumnModel alloc]initWithDataDic:dic ];
                if (![model.img isEqualToString:@""]) {
                    NSString *url = model.img;
                    [ImageArray addObject:url];
                    [url release];
                }
                if (![model.img1 isEqualToString:@""]) {
                    NSString *url = model.img1;
                    [ImageArray addObject:url];
                    [url release];

                }
                if (![model.img2 isEqualToString:@""]) {
                    NSString *url = model.img2;
                    [ImageArray addObject:url];
                    [url release];
                }
                if (![model.img3 isEqualToString:@""]) {
                    NSString *url = model.img3;
                    [ImageArray addObject:url];
                    [url release];
                }
                NSString *str = nil;
                if ([model.type intValue ]== 1) {//专题新闻
                    str = [NSString stringWithFormat:@"%@%@?subjectId=%@",BASE_URL,URL_getThematic_List,model.newsId];
                }else if([model.type intValue ]== 2){//图片新闻
                    str = [NSString stringWithFormat:@"%@%@?titleId=%@",BASE_URL,URL_getImages_List,model.newsId];
                }else {//普通新闻和专题新闻
                    str = [NSString stringWithFormat:@"%@%@?titleId=%@",BASE_URL,URL_getNews_content,model.newsId];

                }
                _path = str;
                _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_path]];
                ASIDownloadCache *cache = [[ASIDownloadCache alloc]init];//创建缓存对象
                NSString *cachePath = [FileUrl getCacheFileURL]; //设置缓存目录
                [cache setStoragePath:cachePath];
                cache.defaultCachePolicy =ASIUseDefaultCachePolicy; //设置缓存策略
                _request.cacheStoragePolicy =ASICachePermanentlyCacheStoragePolicy;
                _request.downloadCache = cache;
                [_request setTimeOutSeconds:60*10];
                [_queue addOperation:_request];
                
            }
//            pic轮播图    
            NSArray *picArray = [dic_model objectForKey:@"picture"];
            for (NSDictionary *dic in picArray) {
                NSString *imgurl = [dic objectForKey:@"pictureUrl"];
                if (![imgurl isEqualToString:@""]) {
                    [ImageArray addObject:imgurl];
                    [imgurl release];
                }

                NSString *str = nil;
                NSString *newsId = [dic objectForKey:@"newsId"];
                if ([ [dic objectForKey:@"type"] intValue ]== 1) {//专题新闻
                    str = [NSString stringWithFormat:@"%@%@?subjectId=%@",BASE_URL,URL_getThematic_List,newsId];
                }else{
                    if (newsId) {
                        str = [NSString stringWithFormat:@"%@%@?titleId=%@",BASE_URL,URL_getNews_content,newsId];
                    }
                }
                if (str) {
                    _path = str;
                    _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_path]];
                    ASIDownloadCache *cache = [[ASIDownloadCache alloc]init];//创建缓存对象
                    NSString *cachePath = [FileUrl getCacheFileURL]; //设置缓存目录
                    [cache setStoragePath:cachePath];
                    cache.defaultCachePolicy =ASIUseDefaultCachePolicy; //设置缓存策略
                    _request.cacheStoragePolicy =ASICachePermanentlyCacheStoragePolicy;
                    _request.downloadCache = cache;
                    [_request setTimeOutSeconds:60*10];
                    [_queue addOperation:_request];
                }
                
            }

            
        }
        _po(@"*******************");
        DLOG(@"*******************,%d",[_queue requestsCount]);

//        所有图片
//        NSArray *allPicArray = [result objectForKey:@"allpicture"];
//        [ImageArray addObjectsFromArray: allPicArray];
//        
//        NSSet *set  = [NSSet setWithArray: ImageArray];
//        for (NSString *url  in [set allObjects]) {
//            if ([url isEqualToString:@"0"]) {
//                continue;
//            }
//            _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
//            [_request setTimeOutSeconds:60*10];
//            [_queue addOperation:_request];
//
//        }
        _queue.downloadProgressDelegate = progressView;
        // 设置queue完成后需要实现的UI方法，根据头文件里面定义，这个UI方法需要一个ASIHTTPRequest 的参数
        _queue.requestDidFinishSelector = @selector(queueDidFinish:);
        [_queue setRequestDidFailSelector:@selector(queueError:)];
        // 如果要实现SEL的方法则根据头文件定义需要把delegate定为self
        _queue.delegate = self;
        DLOG(@"*******************,%d",[_queue requestsCount]);

        [_queue go];
        
        
    } andErrorBlock:^(NSError *error) {
        
    }];
}

- (void)queueDidFinish:(ASIHTTPRequest *)request

{
    
    NSData *responseData = [request responseData];
    NSURL *url =  request.url;
    if (url.query) {
//        非图片
    }else {
//        图片
        NSString *Url = [FileUrl getCacheImageURL];
        NSString * relativeString = [url relativeString];
        NSString * name = [[relativeString componentsSeparatedByString:@"/"] lastObject];
        NSString *firstname = [name componentsSeparatedByString:@"."][0];
        NSString *path = [Url stringByAppendingPathComponent: firstname];
        [responseData writeToFile:path atomically:NO];
    }
    int pro = _progress*100;
    if (pro ==100) {
        [self.eventDelegate finishDownload];
    }
    
}
- (void)queueError:(ASIHTTPRequest *)request

{
    _po(request.url);
    _po([[request error] localizedDescription]);
    [_request clearDelegatesAndCancel];
    [_queue cancelAllOperations];
    [self.eventDelegate errorDownload:INFO_ERROR_OFF_DOWNLOAD];
}
#pragma mark Action
-(void)cencelAction{
    [_request clearDelegatesAndCancel];
    [_queue cancelAllOperations];
    [self.eventDelegate finishDownload];
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
//    NSLog(@"%@",change);
    NSNumber *value = [change objectForKey:@"new"];
    _progress = [value floatValue];
//    NSLog(@"%.1f%%",_progress*100);
    [_progressView setProgress:_progress*100];
    int pro = _progress*100;
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
        [_request clearDelegatesAndCancel];
        [_queue cancelAllOperations];
        [self.eventDelegate errorDownload:INFO_ERROR_OFF_NETWORK];
    }
    else if(status == kReachableViaWWAN) {
        NSLog(@"3G/2G");
    }
    else if(status == kReachableViaWiFi) {
        NSLog(@"WIFI");
    }
}
@end
