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
@implementation NightAndLoadingCell



-(id)init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BrownModelChangeNotification) name:kBrownModelChangeNofication object:nil];
        
    }
    return self;
}


- (id)initWithshoWImage:(BOOL)showImage type:(int)type selected :(BOOL)isselected
{
    self = [self init];
    if (self) {
        self.showImage = showImage;
        self.type = type;
        self.isselected = isselected;
        [self _initView];
    }
    return self;
}
#define mark Notification
#pragma mark - NSNotification actions

//夜间模式
-(void)NightModeChangeNotification:(NSNotification *)nsnotification{
    [self setcolor];
    [self setNeedsLayout];
}
-(void)setcolor{
    self.backgroundColor = [[ThemeManager shareInstance]getBackgroundColor];
}
//打开模式
-(void)BrownModelChangeNotification{
    [self setBrown];
    [self setNeedsLayout];
}
-(void)setBrown{
    UILabel *typeLabel = [[UILabel alloc]init];
    typeLabel.frame = CGRectMake(320 - 40, 60, 40, 20);
    typeLabel.font = [UIFont systemFontOfSize:12];
    typeLabel.textColor = NenNewsTextColor;
    typeLabel.backgroundColor = NenNewsgroundColor;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    if (_type ==0 ) {
        typeLabel.backgroundColor = CLEARCOLOR;
        typeLabel.text = @"";
    }else if (_type ==1) {//专题
        typeLabel.text = @"专题";
    }else if (_type==2){ //图片
        typeLabel.text = @"图集";
    }else if (_type==3){//视频
        typeLabel.text = @"视频";
    }
    [self.contentView addSubview:typeLabel];
    [typeLabel release];
    
    //    标题
    _titleLabel = [Uifactory createLabel:ktext];
    _titleLabel.frame = CGRectMake(100, 10, 320-100-20, 20);
    _titleLabel.numberOfLines = 1;
    [_titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:_titleLabel];
    //     摘要
    if (_isselected) {
        _contentLabel = [Uifactory createLabel:kselectText];
    }else{
        _contentLabel = [Uifactory createLabel:ktext];
    }
    _contentLabel.frame =CGRectMake(100, 80-20-10-10, 320-100-20, 30);
    _contentLabel.numberOfLines = 2;
    [_contentLabel setFont:[UIFont systemFontOfSize:10]];
    [self.contentView addSubview:_contentLabel];
    if (_showImage) {
        //图片视图
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 60)];
        _imageView.backgroundColor = CLEARCOLOR;
        [self.contentView addSubview:_imageView];
    }else{
        _titleLabel.frame = CGRectMake(10, 10, 300, 20);
        _contentLabel.frame = CGRectMake(10, 40, 300, 30);
        [_imageView setHidden:YES];
    }
    
    
}

-(void)_initView {
//    设置布局
    [self setBrown];
//    设置背景颜色
    [self setcolor];
}

//layoutSubviews展示数据，子视图布局
-(void)layoutSubviews{
    [super layoutSubviews];
    //图片视图
    if (_showImage) {
        [_imageView setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:@"logo_80x60.png"]];
    }
//    标题
    _titleLabel.text = _model.title;
//    内容
    _contentLabel.text = _model.newsAbstract;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [_contentLabel setText:kselectText];
    FMDatabase *db = [FileUrl getDB];
    [db open];
    NSString *newsId = self.model.newsId;
    [db executeUpdate:@"update columnData set isselected = 1 where newsId = ?" ,newsId];
    [db close];
    [super setSelected:selected animated:animated];
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_imageView release];
    [super dealloc];
}

@end
