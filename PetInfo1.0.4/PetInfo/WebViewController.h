//
//  WebViewController.h
//  东北新闻网
//
//  Created by 佐筱猪 on 14-1-1.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController<UIWebViewDelegate>{
    NSString *_url;

}
@property (retain, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)goBack:(id)sender;

- (IBAction)goForward:(id)sender;

- (IBAction)reload:(id)sender;

- (id)initWithUrl:(NSString *)url;

@end
