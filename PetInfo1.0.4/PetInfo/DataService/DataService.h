//
//  DataService.h
//  testLanucher
//
//  Created by 佐筱猪 on 13-11-18.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@protocol ASIRequest <NSObject>
//可选事件
@optional
- (void)requestFinished:(id )result;
- (void)requestFailed:(ASIHTTPRequest *)request;
@end


typedef void (^RequestFinishBlock)(id result);
typedef void (^RequestErrorBlock)(NSError *error);
@interface DataService : NSObject <ASIHTTPRequestDelegate>

@property (nonatomic,assign) id<ASIRequest> eventDelegate;
//异步获取
+(ASIHTTPRequest *)requestWithURL:(NSString *)urlstring andparams:(NSMutableDictionary *)params andhttpMethod:(NSString *) httpMethod andCache :(ASICachePolicy)ASIcache  completeBlock:(RequestFinishBlock)block andErrorBlock:(RequestErrorBlock)errorBlock;
//只读本地的异步获取
+(ASIHTTPRequest *)nocacheWithURL:(NSString *)urlstring andparams:(NSMutableDictionary *)params  completeBlock:(RequestFinishBlock) block andErrorBlock:(RequestErrorBlock) errorBlock;
//访问网络，机型对比的异步获取
+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlstring andparams:(NSMutableDictionary *)params andhttpMethod: (NSString *)httpMethod completeBlock:(RequestFinishBlock) block andErrorBlock:(RequestErrorBlock) errorBlock;

- (ASIHTTPRequest *) requestWithURL:(NSString *)urlstring andparams:(NSMutableDictionary *)params
                            isJoint:(BOOL)isJoint    andhttpMethod: (NSString *)httpMethod ;


//+ (ASIHTTPRequest *)sendImageWithURL:(NSString *)urlstring andparams:(NSMutableDictionary *)params  completeBlock:(RequestFinishBlock) block andErrorBlock:(RequestErrorBlock) errorBlock;

@end
