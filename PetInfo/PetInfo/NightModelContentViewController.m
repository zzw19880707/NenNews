//
//  NightModelContentViewController.m
//  东北新闻网
//
//  Created by 佐筱猪 on 14-1-1.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "NightModelContentViewController.h"
#import "NewsContentModel.h"
#import "Uifactory.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PlayerViewController.h"
@interface NightModelContentViewController ()

@end

@implementation NightModelContentViewController
#define scr_width 10
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showHUD:INFO_RequestNetWork isDim:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.titleID forKey:@"titleId"];//
    [DataService requestWithURL:URL_getNews_content andparams:params andhttpMethod:@"POST" completeBlock:^(id result) {
        NSDictionary *dic = [result objectForKey:@"news"];
        if ((NSNull *)dic == [NSNull null]) {
            [self hideHUD];
            [self showHUD:INFO_ERROR isDim:NO];
            [self performSelector:@selector(hideHUD) withObject:nil afterDelay:1];
            return ;
        }
        NewsContentModel *model = [[NewsContentModel alloc]initWithDataDic:dic];
        self.titleLabel = model.title;
        self.url = model.url;
        self.content = model.content;
        [self showHUDComplete:INFO_EndRequestNetWork];
        _createtime = model.createtime;
        _comAddress = model.comAddress;
        _abnewsArray = model.abnews;
        [self performSelector:@selector(hideHUD) withObject:nil afterDelay:.5];

        dispatch_async(dispatch_get_main_queue(), ^{
            //普通新闻
            if ([self.type isEqualToString:@"0"]) {
                [self _initView];
                
            }
            //图片新闻
            else if ([self.type isEqualToString:@"2"]){
                
            }
//            视频新闻
            else if ([self.type isEqualToString:@"3"]){
                [self _initViedoView];
            }
            else {
                
            }
        });
    } andErrorBlock:^(NSError *error) {
        
    }];
}
//普通新闻
-(void)_initView{
    _imageArray = [[NSMutableArray alloc]init];
    _contentArray = [_content componentsSeparatedByString:@"<IMG>"];
    UIScrollView *backgroundView = [Uifactory createScrollView];
    backgroundView.frame = CGRectMake(0,20+44, ScreenWidth, ScreenHeight);
    float height = 0.0;
//    标题
    UILabel *titleLabel = [Uifactory createLabel:ktext];
    titleLabel.frame = CGRectMake(scr_width, height, ScreenWidth, 20);
    titleLabel.text = self.titleLabel;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = UITextAlignmentLeft;
    //设置字体大小适应label宽度
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [backgroundView addSubview:titleLabel];
    height +=30;

//    来源
    UILabel *comAddress = [Uifactory createLabel:kselectText];
    comAddress.frame = CGRectMake(scr_width, height, 80, 10);
    comAddress.text = _comAddress;
    comAddress.font = [UIFont systemFontOfSize:12];
    comAddress.adjustsFontSizeToFitWidth = YES;
    [backgroundView addSubview:comAddress];
//    创建时间
    UILabel *createtime = [Uifactory createLabel:kselectText];
    createtime.frame = CGRectMake(comAddress.right+scr_width, height, 80, 10);
    createtime.text = _createtime;
    createtime.font = [UIFont systemFontOfSize:12];
    createtime.adjustsFontSizeToFitWidth = YES;
    [backgroundView addSubview:createtime];
    height+=20;
    
    //初始化图片列表
    for (int i =0 ; i< _contentArray.count ; i++){
        NSString *content = _contentArray[i];
        //图片
        if (i%2==1) {
            [_imageArray addObject:content];
            UIButton *button = [[UIButton alloc]init];
            [button setImageWithURL:[NSURL URLWithString:content] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo_280x210.png"]];
            button.frame = CGRectMake(scr_width,height, 280, 210);
            [backgroundView addSubview:button];
            [button release];
            height+=220;
        }
        //文字
        else
        {
            UITextView *textView = [[UITextView alloc]init];
            textView.text = content;
            if (content.length<=2) {
                continue;
            }
            textView.font = [UIFont systemFontOfSize:10];
            textView.textAlignment = 
            textView.scrollEnabled = NO;
            [textView setEditable:NO];
//            CGSize size = [content sizeWithFont:textView.font constrainedToSize:CGSizeMake(300-16, 10000)];
            textView.frame = CGRectMake(scr_width, height, ScreenWidth-scr_width*2, 0);
            [textView sizeToFit];
            [backgroundView addSubview:textView];
            height+=textView.height;
//            height+=26;
        }
    }
//有相关新闻
    if (_abnewsArray.count>0) {
        UILabel *abnewslabel = [Uifactory createLabel:ktext];
        abnewslabel.text= @"相关新闻";
        abnewslabel.font = [UIFont systemFontOfSize:13];
        abnewslabel.frame = CGRectMake(10, height, 50, 15);
        [backgroundView addSubview:abnewslabel];
        height+=20;
        for (int i = 0 ; i< _abnewsArray.count ; i++) {
            int tag = [[_abnewsArray[i] objectForKey:@"titleId"] intValue];
            NSString *title = [_abnewsArray[i] objectForKey:@"title"];
//相关新闻图标
            UIImageView *icon = [[UIImageView alloc]init];
            icon.image = [UIImage imageNamed:@""];
            icon.frame = CGRectMake(20, height+5, 15, 20);
            [backgroundView addSubview:icon];
            [icon release];
//            相关新闻按钮
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake(40, height, ScreenWidth - 40 -20, 30);
            [button setTitle:title forState:UIControlStateNormal];
            [button addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = tag;
            [backgroundView addSubview:button];
            [button release];
            height +=35;
        }
        
    }
    backgroundView.contentSize = CGSizeMake(ScreenWidth, height+40);

    [self.view addSubview:backgroundView];
    
}


//图片新闻
-(void)_initImageView{
    
}
//视频新闻
-(void)_initViedoView{
    UIScrollView *backgroundView = [Uifactory createScrollView];
    backgroundView.frame = CGRectMake(0,20+44, ScreenWidth, ScreenHeight);
    float height = 0.0;
    //    标题
    UILabel *titleLabel = [Uifactory createLabel:ktext];
    titleLabel.frame = CGRectMake(scr_width, height, ScreenWidth, 20);
    titleLabel.text = self.titleLabel;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = UITextAlignmentLeft;
    //设置字体大小适应label宽度
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [backgroundView addSubview:titleLabel];
    height +=30;
    
    //    来源
    UILabel *comAddress = [Uifactory createLabel:kselectText];
    comAddress.frame = CGRectMake(scr_width, height, 80, 10);
    comAddress.text = _comAddress;
    comAddress.font = [UIFont systemFontOfSize:12];
    comAddress.adjustsFontSizeToFitWidth = YES;
    [backgroundView addSubview:comAddress];
    //    创建时间
    UILabel *createtime = [Uifactory createLabel:kselectText];
    createtime.frame = CGRectMake(comAddress.right+scr_width, height, 80, 10);
    createtime.text = _createtime;
    createtime.font = [UIFont systemFontOfSize:12];
    createtime.adjustsFontSizeToFitWidth = YES;
    [backgroundView addSubview:createtime];
    height+=20;
    
//    背景
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, height, 280, 210)];
    [backgroundView addSubview:view];
    [view release];
    
//    数据  第一个为图片地址  第二个为视频地址  第三个为文字描述
    _contentArray = [_content componentsSeparatedByString:@"<VIEDO>"];
    UIImageView *imageView = [[UIImageView alloc]init];
    NSString *imageURL = _contentArray[0];
    if (imageURL.length<=2) {
        [imageView setImage:[UIImage imageNamed:@"logo_280x210.png"]];

    }else{
        [imageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"logo_280x210.png"]];
    }
    imageView.frame = CGRectMake(0, 0, 280, 210);
    imageView.alpha = .8;
    [view addSubview:imageView];
    [imageView release];
//    视频图片
    UIButton *button =[[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"play_button.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 280, 210);
//    button.imageView.alpha = .5;
    [view addSubview:button];
    [button release];
    height +=210;
//    文字
    NSString *titleContent = _contentArray[2];
    if (titleContent.length<=2) {
        
    }else{
        //    文字描述
        UILabel *titleLable = [Uifactory createLabel:ktext];
        titleLable.frame = CGRectMake(20, height, 200, 15);
        titleLable.textAlignment = NSTextAlignmentLeft;
        titleLable.text = _contentArray[2];
        [backgroundView addSubview:titleLable];
        [titleLable release];
        height +=20;
    }

    backgroundView.contentSize = CGSizeMake(ScreenWidth, height+40);
    
    [self.view addSubview:backgroundView];

}
#pragma  mark aciton
-(void)pushAction :(UIButton *) button {
    int tag = button.tag;
    NightModelContentViewController *nightModel = [[NightModelContentViewController alloc]init];
    nightModel.type = @"0";//model.type;
    nightModel.titleID = [NSString stringWithFormat:@"%d",tag];
    [self.navigationController pushViewController:nightModel animated:YES];
}
-(void)playAction :(UIButton *)button {
    NSString *ktype =[self getConnectionAvailable];
    if ([ktype isEqualToString:@"none"]) {
        alertContent(INFO_NetNoReachable);
    }else if([ktype isEqualToString:@"wifi"]){
        [self play];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:INFO_Net3GReachable delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"取消", nil];
        [alert show];
        [alert release];
    }
}
-(void)play {
    NSString *urlstring = _contentArray[1];// @"http://media.nen.com.cn/0/11/94/70/11947049_822501.mp4";
    NSURL *url = [NSURL URLWithString:urlstring];
    MPMoviePlayerViewController *playerViewController = [[PlayerViewController alloc] initWithContentURL:url];
    [self presentViewController:playerViewController animated:YES completion:NULL];

}
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 ) {
        
    }else{
        [self play];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc {
    RELEASE_SAFELY(_content);
    [super dealloc];
}
@end
