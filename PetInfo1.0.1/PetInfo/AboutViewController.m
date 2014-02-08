//
//  AboutViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"关于";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *aboutPath = [[NSBundle mainBundle] pathForResource: @"about" ofType: @"html"];
    NSError *error = nil;
    NSStringEncoding encoding;
    NSString *htmlString = [NSString stringWithContentsOfFile: aboutPath usedEncoding: &encoding error: &error];

    [_webView loadHTMLString: htmlString baseURL: nil];
    
}



#pragma mark 内存管理
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webView release];

    [super dealloc];
}
- (void)viewDidUnload {
    [_webView stopLoading];

    [_webView release];
    _webView = nil;

    [super viewDidUnload];
    

}
@end
