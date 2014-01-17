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
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "ThemeManager.h"
#import "MBProgressHUD.h"
@interface NightModelContentViewController (){
    UIImageView *_imageView;
    BOOL _isImageLoad;
    NSMutableArray *_imageViewArray;
    int _Contenttype;//0 普通新闻 1 有文字的图片新闻 2 无文字的图片新闻
}
@end

@implementation NightModelContentViewController
@synthesize backgroundView = _backgroundView;
#define scr_width 10
@synthesize contentArray=_contentArray;
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
    self.view.backgroundColor = [[ThemeManager shareInstance] getBackgroundColor];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.newsId forKey:@"titleId"];//
    [self getConnectionAlert];

    //图片新闻
    if (self.type ==2) {
            [DataService requestWithURL:URL_getImages_List andparams:params andhttpMethod:@"GET" completeBlock:^(id result) {
                NSDictionary *dic = [result objectForKey:@"news"];
                if ((NSNull *)dic == [NSNull null]) {
                    [self hideHUD];
                    [self showHUD:INFO_ERROR isDim:YES];
                    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:1];
                    return ;
                }
                NewsContentModel *model = [[NewsContentModel alloc]initWithDataDic:dic];
                self.titleLabel = model.title;
                self.url = model.url;
                self.content = model.content;
                [self showHUDComplete:INFO_EndRequestNetWork];
                _createtime = model.pubTime;
                _comAddress = model.comeAddress;
                _imageArray = [result objectForKey:@"picture"] ;
                [self performSelector:@selector(hideHUD) withObject:nil afterDelay:.5];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_imageArray.count==0) {
                        _Contenttype = 0;
                        [self _initView];
                    }else{
                        [self _initImageView];

                    }
                });
                
                
            } andErrorBlock:^(NSError *error) {
                [self performSelector:@selector(hideHUD) withObject:nil afterDelay:.5];
            }];

    }else{
            [DataService requestWithURL:URL_getNews_content andparams:params andhttpMethod:@"GET" completeBlock:^(id result) {
                NSDictionary *dic = [result objectForKey:@"news"];
                if ((NSNull *)dic == [NSNull null]) {
                    [self hideHUD];
                    [self showHUD:INFO_ERROR isDim:YES];
                    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:1];
                    return ;
                }
                NewsContentModel *model = [[NewsContentModel alloc]initWithDataDic:dic];
                self.titleLabel = model.title;
                self.url = model.url;
                self.content = model.content;
                [self showHUDComplete:INFO_EndRequestNetWork];
                _createtime = model.pubTime;
                _comAddress = model.comeAddress;
                _abnewsArray = [result objectForKey:@"abnews"] ;
                [self performSelector:@selector(hideHUD) withObject:nil afterDelay:.5];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //普通新闻
                    if (self.type ==0) {
                        _Contenttype = 0;
                        [self _initView];
                        
                    }
                    //图片新闻
                    else if (self.type==2){
                        
                    }
                    //            视频新闻
                    else if (self.type==3){
                        [self _initViedoView];
                    }
                    else {
                        
                    }
                });
            } andErrorBlock:^(NSError *error) {
                [self performSelector:@selector(hideHUD) withObject:nil afterDelay:.5];
                
            }];
    }
    
    
}

-(void) initTitle {
    self.backgroundView = [Uifactory createScrollView] ;
    self.backgroundView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight);
    _height = 0.0;
    //    标题
    UILabel *titleLabel = [Uifactory createLabel:ktext];
    titleLabel.frame = CGRectMake(scr_width, _height, ScreenWidth-20, 20);
    titleLabel.text = self.titleLabel;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.numberOfLines = 0;
//    titleLabel.textAlignment = UITextAlignmentLeft;
    //设置字体大小适应label宽度
//    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [titleLabel sizeToFit];
    [self.backgroundView addSubview:titleLabel];
    _height +=titleLabel.height +10;
    
    //    来源
    UILabel *comAddress = [Uifactory createLabel:kselectText];
    comAddress.frame = CGRectMake(scr_width, _height, 80, 15);
    comAddress.text = _comAddress;
    comAddress.font = [UIFont systemFontOfSize:15];
    comAddress.adjustsFontSizeToFitWidth = YES;
    [self.backgroundView addSubview:comAddress];
    //    创建时间
    UILabel *createtime = [Uifactory createLabel:kselectText];
    createtime.frame = CGRectMake(comAddress.right+scr_width, _height, 80, 15);
    createtime.text = _createtime;
    createtime.font = [UIFont systemFontOfSize:15];
    createtime.adjustsFontSizeToFitWidth = YES;
    [self.backgroundView addSubview:createtime];
    _height+=25;

}
//普通新闻
-(void)_initView{
    _imageArray = [[NSMutableArray alloc]init];
    _contentArray = [_content componentsSeparatedByString:@"<IMG>"];
    [self initTitle];
    //初始化图片列表
    for (int i =0 ; i< _contentArray.count ; i++){
        NSString *content = _contentArray[i];
        //图片
        if (i%2==1) {
            NSDictionary *dic = @{@"pictureUrl": content,@"pictureContent":@""};
            [_imageArray addObject:dic];
            UIImageView *imageView = [[UIImageView alloc]init];
            [imageView setImageWithURL:[NSURL URLWithString:content]  placeholderImage:[UIImage imageNamed:@"logo_280x210.png"]];
            imageView.frame = CGRectMake(scr_width,_height, 280, 210);
            imageView.tag = 1300+ i/2;
            imageView.userInteractionEnabled =  YES;
            // 内容模式
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            [self.backgroundView addSubview:imageView];
//            [imageView release];
            _height+=220;
        }
        //文字
        else
        {
            UITextView *textView = [Uifactory createTextView];
            textView.text = content;
            if (content.length<=2) {
                continue;
            }
//            textView.textAlignment =
            textView.scrollEnabled = NO;
            [textView setEditable:NO];
//            CGSize size = [content sizeWithFont:textView.font constrainedToSize:CGSizeMake(300-16, 10000)];
            textView.frame = CGRectMake(scr_width, _height, ScreenWidth-scr_width*2, 0);
            [textView sizeToFit];
            [_backgroundView addSubview:textView];
            _height+=textView.height;
        }
    }
//有相关新闻
    if (_abnewsArray.count>0) {
        UILabel *abnewslabel = [Uifactory createLabel:ktext];
        abnewslabel.text= @"相关新闻";
        abnewslabel.font = [UIFont systemFontOfSize:13];
        abnewslabel.frame = CGRectMake(10, _height, 100, 15);
        [_backgroundView addSubview:abnewslabel];
        _height+=20;
        for (int i = 0 ; i< _abnewsArray.count ; i++) {
            int tag = i;
            NSString *title = [_abnewsArray[i] objectForKey:@"title"];
//相关新闻图标
            UIImageView *icon = [[UIImageView alloc]init];
            icon.image = [UIImage imageNamed:@"point.png"];
            icon.frame = CGRectMake(20, _height+5, 20, 20);
            [_backgroundView addSubview:icon];
//            [icon release];
//            相关新闻按钮
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake(45, _height, ScreenWidth - 40 -20, 30);
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = tag;
            [_backgroundView addSubview:button];
//            [button release];
            _height +=35;
        }
        
    }
    _height+=26;

    _backgroundView.contentSize = CGSizeMake(ScreenWidth, _height+40);

    [self.view addSubview:_backgroundView];
    
}


//图片新闻
-(void)_initImageView{
    
    if (_content.length > 0 ) {
        [self initTitle];
        //    文字描述
        UILabel *titleLable = [Uifactory createLabel:ktext];
        titleLable.frame = CGRectMake(20, _height, 280, 15);
        titleLable.textAlignment = NSTextAlignmentLeft;
        titleLable.numberOfLines = 0;
        titleLable.text = _content;
        titleLable.font = [UIFont systemFontOfSize:13];
        [titleLable sizeToFit];
        [self.backgroundView addSubview:titleLable];
//        [titleLable release];
        _height +=titleLable.height+10;

//        添加一张图片
        NSDictionary *dic = _imageArray[0];
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(20, _height, 280, 210);
        [_imageView setImageWithURL:[dic objectForKey:@"pictureUrl"] placeholderImage:[UIImage imageNamed:@"logo_280x210.png"]];
        _imageView.userInteractionEnabled = YES;
        // 内容模式
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        

        [self.backgroundView  addSubview:_imageView];
        [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        
        
        UILabel *typeLabel = [[UILabel alloc]init];
        typeLabel.frame = CGRectMake(0, 210 - 20, 40, 20);
        typeLabel.font = [UIFont systemFontOfSize:12];
        typeLabel.textColor = NenNewsTextColor;
        typeLabel.backgroundColor = NenNewsgroundColor;
        typeLabel.textAlignment = NSTextAlignmentCenter;
        typeLabel.text = @"图集";
        [_imageView addSubview:typeLabel];
//        [typeLabel release];

        
        _height+=220;
        UILabel *titleLabel = [Uifactory createLabel:kselectText];
        titleLabel.frame = CGRectMake(20, _height, 280, 15);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = 0;
        titleLabel.text = self.titleLabel;
        titleLabel.font = [UIFont systemFontOfSize:10];
        [titleLabel sizeToFit];
        [self.backgroundView addSubview:titleLabel];
//        [titleLabel release];
        _height +=titleLable.height+10;

        self.backgroundView.contentSize = CGSizeMake(ScreenWidth, _height+40);
        _Contenttype = 1;
        [self.view addSubview:self.backgroundView];
    }else {
        _isImageLoad =YES;
        _Contenttype = 2;
        [self initImage:0];
    }
}

-(void)initImage:(int)tag {
    int count = _imageArray.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {

        // 替换为中等尺寸图片
        NSString *url = [[_imageArray[i] objectForKey:@"pictureUrl"] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
//        UIImageView *view = (UIImageView *)VIEWWITHTAG(self.view, 1300+i);
        UIImageView *view;
        _po(self.view.subviews);
        if (_Contenttype != 0) {//有文字图片新闻
//            view = self.view.subviews[i+1];
//        }else if (_Contenttype == 2){//无文字的图片新闻
            view = _imageView;

        }else{
            view =(UIImageView *) VIEWWITHTAG(self.backgroundView, 1300+i);
        }
        photo.srcImageView = view;
//        self.view.subviews[i]; // 来源于哪个UIImageView
        
        photo.title = self.titleLabel;
        photo.content = [_imageArray[i] objectForKey:@"pictureContent"];
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.delegate = self;
    browser.currentPhotoIndex = tag; // 弹出相册时显示的第一张图片是？
    
    browser.photos = photos; // 设置所有的图片
    [browser show];


}

//视频新闻
-(void)_initViedoView{
    [self initTitle];
//    背景
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, _height, 280, 210)];
    [_backgroundView addSubview:view];
//    [view release];
    
//    数据  第一个为图片地址  第二个为视频地址  第三个为文字描述
    self.contentArray = [_content componentsSeparatedByString:@"<VIEDO>"];
    UIImageView *imageView = [[UIImageView alloc]init];
    NSString *imageURL = _contentArray[0];
    if (!self.ImageUrl) {
        self.ImageUrl = imageURL;
    }
    if (imageURL.length<=2) {
        [imageView setImage:[UIImage imageNamed:@"logo_280x210.png"]];

    }else{
        [imageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"logo_280x210.png"]];
    }
    imageView.frame = CGRectMake(0, 0, 280, 210);
    imageView.alpha = .8;
    imageView.contentMode= UIViewContentModeScaleAspectFit;
    [view addSubview:imageView];
//    [imageView release];
//    视频图片
    UIButton *button =[[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"play_button.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 280, 210);
//    button.imageView.alpha = .5;
    [view addSubview:button];
//    [button release];
    _height +=210;
    if (_contentArray.count>2) {
        //    文字
        NSString *titleContent = _contentArray[2];
        if (titleContent.length<=2) {
            
        }else{
            //    文字描述
            UILabel *titleLable = [Uifactory createLabel:ktext];
            titleLable.frame = CGRectMake(20, _height, 200, 15);
            titleLable.textAlignment = NSTextAlignmentLeft;
            titleLable.text = _contentArray[2];
            [_backgroundView addSubview:titleLable];
//            [titleLable release];
            _height +=20;
        }

    }else{
        
           }


    _backgroundView.contentSize = CGSizeMake(ScreenWidth, _height+40);
    
    [self.view addSubview:_backgroundView];

}
#pragma  mark aciton

//点击图片
-(void)tapImage:(UITapGestureRecognizer *)tap{
    if (_Contenttype ==0) {
        [self initImage:(tap.view.tag-1300)];

    }else{
        [self initImage:0];
    }
}


-(void)pushAction :(UIButton *) button {
    int tag = button.tag;
    NightModelContentViewController *nightModel = [[NightModelContentViewController alloc]init];
    nightModel.type = 0;//model.type;
    nightModel.newsId = [NSString stringWithFormat:@"%@", [_abnewsArray[tag] objectForKey:@"titleId"]];
    [self.navigationController pushViewController:nightModel animated:YES];
}
-(void)playAction :(UIButton *)button {
    NSString *ktype =[self getConnectionAvailable];
    if ([ktype isEqualToString:@"none"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:INFO_NetNoReachable
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }else if([ktype isEqualToString:@"wifi"]){
        
        [self play];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:INFO_Net3GReachable delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
        [alert show];
//        [alert release];
    }
}
-(void)play {
    NSString *urlstring ;
    if (_contentArray.count == 1) {
        urlstring = _contentArray[0];// @"http://media.nen.com.cn/0/11/94/70/11947049_822501.mp4";

    }else{
        urlstring = _contentArray[1];// @"http://media.nen.com.cn/0/11/94/70/11947049_822501.mp4";

    }
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

#pragma mark MJPhotoBrowserDelegate
-(void)viewremove{
    if (_isImageLoad) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}
//-(void)dealloc {
//    RELEASE_SAFELY(_abnewsArray);
//    RELEASE_SAFELY(_content);
//    RELEASE_SAFELY(_imageArray);
//    [super dealloc];
//}
@end
