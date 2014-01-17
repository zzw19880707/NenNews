//
//  NightAndLoadingCell.m
//  东北新闻网
//
//  Created by tenyea on 13-12-29.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "NightAndLoadingCell.h"
#import "Uifactory.h"
#import "ColumnModel.h"
#import "UIImageView+WebCache.h"
#import "ThemeManager.h"
#import "FMDatabase.h"
#import "FileUrl.h"
#import "Reachability.h"
@implementation NightAndLoadingCell



-(id)init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BrownModelChangeNotification) name:kBrownModelChangeNofication object:nil];
        
    }
    return self;
}


- (id)initWithshoWImage:(BOOL)showImage type:(int)type 
{
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeDetailCell"];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BrownModelChangeNotification) name:kBrownModelChangeNofication object:nil];
        self.showImage = showImage;
        self.type = type;
        self.isselected = NO;
        [self _initView];
    }
    return self;
}
#define mark Notification
#pragma mark - NSNotification actions

//夜间模式
-(void)NightModeChangeNotification:(NSNotification *)nsnotification{
    [self setcolor];
//    [self setNeedsLayout];
}
-(void)setcolor{
    self.backgroundColor = [[ThemeManager shareInstance]getBackgroundColor];

}
//打开模式
-(void)BrownModelChangeNotification{
    [self setBrown];
//    [self setNeedsLayout];
}
//设置打开模式
-(void)setBrown{
    
    if (_showImage) {
        int brose = [[ThemeManager shareInstance]getBroseModel];
        if (brose == 0) {//智能模式
            if ([[self getConnectionAvailable] isEqualToString:@"wifi"]) {
                [self addImage];
            }else{
                [self hiddenImage];
            }
        }else if(brose ==1){//无图
            [self hiddenImage];
        }else{//全部图
            [self addImage];
        }
    }else{
        [self hiddenImage];
    }
}
-(void)addImage{
    _titleLabel.frame = CGRectMake(100, 10, 320-100-20, 20);
    _contentLabel.frame =CGRectMake(100, 80-20-10-10, 320-100-20, 30);
    [_imageView setHidden:NO];
}
-(void)hiddenImage{
    _titleLabel.frame = CGRectMake(10, 10, 300, 20);
    _contentLabel.frame = CGRectMake(10, 40, 300, 30);
    [_imageView setHidden:YES];

}

//判断当前是否有网络
-(NSString *) getConnectionAvailable{
    NSString *isExistenceNetwork = @"none";
    Reachability *reach = [Reachability reachabilityWithHostName:BASE_URL];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = @"none";
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = @"wifi";
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = @"3g";
            //NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
}


-(void)_initCell {
    
    //    标题
//    if (_isselected) {
//        _titleLabel = [Uifactory createLabel:kselectText];
//    }
//    else{
        _titleLabel = [Uifactory createLabel:ktext];
//    }
    _titleLabel.frame = CGRectMake(100, 10, 320-100-20, 20);
    _titleLabel.numberOfLines = 1;
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [self.contentView addSubview:_titleLabel];
    //     摘要
    _contentLabel = [Uifactory createLabel:kselectText];

    _contentLabel.frame =CGRectMake(100, 80-20-10-10, 320-100-20, 30);
    _contentLabel.numberOfLines = 2;
    [_contentLabel setFont:[UIFont systemFontOfSize:10]];
    [self.contentView addSubview:_contentLabel];
    //图片视图
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 60)];
    _imageView.backgroundColor = CLEARCOLOR;
    [self.contentView addSubview:_imageView];
    UILabel *typeLabel = [[UILabel alloc]init];
    typeLabel.frame = CGRectMake(320 - 40, 60, 40, 20);
    typeLabel.font = [UIFont systemFontOfSize:12];
    typeLabel.textColor = NenNewsTextColor;
    typeLabel.backgroundColor = NenNewsgroundColor;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    if (_type ==0 ) {
        typeLabel.backgroundColor = CLEARCOLOR;
        typeLabel.text = @"";
        [typeLabel setHidden:YES];
    }else if (_type ==1) {//专题
        typeLabel.text = @"专题";
    }else if (_type==2){ //图片
        typeLabel.text = @"图集";
    }else if (_type==3){//视频
        typeLabel.text = @"视频";
    }
    [self.contentView addSubview:typeLabel];
    [typeLabel release];

    [self setBrown];
}
-(void)_initView {
//    设置布局
    [self _initCell];
//    设置背景颜色
    [self setcolor];
}

//layoutSubviews展示数据，子视图布局
-(void)layoutSubviews{
    [super layoutSubviews];
    //图片视图
//    if (!_imageView.hidden) {
//        [_imageView setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:@"logo_80x60.png"]];
//    }
//    标题
    _titleLabel.text = _model.title;
//    内容
    _contentLabel.text = _model.newsAbstract;
//    _pn(_model.isselected);
    if (_model.isselected==YES) {
        _titleLabel.colorName = kselectText;
    }else{
        _titleLabel.colorName = ktext;
    }
    //图片视图

    if (_model.img.length==0) {
        [self hiddenImage];
    }else{
        [self addImage];
        [_imageView setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:@"logo_80x60.png"]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

    _titleLabel.isSelect = selected;
    [super setSelected:selected animated:animated];
    if (selected) {
//        _isselected=YES;
        _model.isselected = YES;
    }
    

}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_imageView release];
    [super dealloc];
}

@end
