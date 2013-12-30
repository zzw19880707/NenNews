//
//  LocationViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-21.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(AppDelegate *)appDelegate{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    return  appDelegate;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = NenNewsgroundColor;
	[self.view setBackgroundColor:NenNewsgroundColor];
    
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    
    
    if (self.isCancelButton) {
        //        UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cencel)];
        //        self.navigationItem.leftBarButtonItem=[cancelItem autorelease];
        UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = NenNewsgroundColor;
        //        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navagiton_back.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 40, 30);
        //        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(cencel) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = [backItem autorelease];
    }else{
        if (viewControllers.count > 1 ) {
            UIButton *button = [[UIButton alloc]init];
            button.backgroundColor = NenNewsgroundColor;
            //        [button setTitle:@"返回" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"navagiton_back.png"] forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, 40, 30);
            //        button.showsTouchWhenHighlighted = YES;
            [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            self.navigationItem.leftBarButtonItem = [backItem autorelease];
        }
    }
}

#pragma mark ----按钮事件
-(void)cencel{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    UILabel *titlelabel=[[UILabel alloc]initWithFrame:CGRectZero];
    titlelabel.font=[UIFont boldSystemFontOfSize:18.0f];
    titlelabel.backgroundColor= NenNewsgroundColor;
    titlelabel.text=title;
    titlelabel.textColor=NenNewsTextColor;
    [titlelabel sizeToFit];
    self.navigationItem.titleView = [titlelabel autorelease];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
