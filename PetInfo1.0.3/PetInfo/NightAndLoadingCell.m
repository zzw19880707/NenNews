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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BrownModelChangeNotification) name:kBrownModelChangeNofication object:nil];
        
    }
    return self;
}
- (id)initWithshoWImage:(BOOL)showImage type:(int)type 
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeDetailCell"];
    if (self) {
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
            if ([[DataCenter  getConnectionAvailable] isEqualToString:@"wifi"]) {
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
    _titleLabel.frame = CGRectMake(10, 10, 300-50, 20);
    _contentLabel.frame = CGRectMake(10, 40, 300, 30);
    [_imageView setHidden:YES];

}


-(void)_initCell {
    
    //    标题

    _titleLabel = [Uifactory createLabel:ktext];
    _titleLabel.frame = CGRectMake(100, 10, 320-100-20, 20);
    _titleLabel.numberOfLines = 0;
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
    _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(320 - 40, 55, 40, 15)];
    _typeLabel.font = [UIFont systemFontOfSize:10];
    _typeLabel.textColor = NenNewsTextColor;
    _typeLabel.backgroundColor = NenNewsgroundColor;
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_typeLabel];
    _typeUpLabel= [[UILabel alloc]initWithFrame:CGRectMake(320 - 40, 5, 40, 13)];
    _typeUpLabel.font = [UIFont systemFontOfSize:10];
    _typeUpLabel.textColor = NenNewsTextColor;
    _typeUpLabel.backgroundColor = NenNewsgroundColor;
    _typeUpLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_typeUpLabel];
    [self setBrown];
    
//    三张图的图片视图
    
    //图片视图
    _imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 40, 80, 60)];
    _imageView1.backgroundColor = CLEARCOLOR;
    _imageView1.hidden = YES;
    [self.contentView addSubview:_imageView1];
    _imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(120, 40, 80, 60)];
    _imageView2.backgroundColor = CLEARCOLOR;
    _imageView2.hidden = YES;
    [self.contentView addSubview:_imageView2];
    _imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(220, 40, 80, 60)];
    _imageView3.backgroundColor = CLEARCOLOR;
    _imageView3.hidden = YES;
    [self.contentView addSubview:_imageView3];
    _imageTitleLabel = [Uifactory createLabel:ktext];
    _imageTitleLabel.frame = CGRectMake(20, 10, 320-20-50, 20);
    _imageTitleLabel.numberOfLines = 0;
    _imageTitleLabel.hidden = YES;
    [_imageTitleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [self.contentView addSubview:_imageTitleLabel];
}
-(void)_initView {
//    设置布局
    [self _initCell];

}

//layoutSubviews展示数据，子视图布局
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_model.img1.length>2&&_model.img2.length>2&&_model.img3.length>2) {
        _titleLabel.hidden=YES;
        _contentLabel.hidden=YES;
        _typeLabel.hidden= YES;
        _typeUpLabel.hidden = YES;
        _imageView.hidden = YES;
        
        _imageTitleLabel.hidden= NO;
        _imageView1.hidden = NO;
        _imageView2.hidden = NO;
        _imageView3.hidden = NO;
        
        _imageTitleLabel.text = _model.title;

        if([[DataCenter getConnectionAvailable] isEqualToString:@"none"]){
            NSString *filename1 = [[_model.img1 componentsSeparatedByString:@"/"] lastObject];
            NSString *filename2 = [[_model.img2 componentsSeparatedByString:@"/"] lastObject];
            NSString *filename3 = [[_model.img3 componentsSeparatedByString:@"/"] lastObject];

            NSString *name1 = [filename1 componentsSeparatedByString:@"."][0];
            NSString *name2 = [filename2 componentsSeparatedByString:@"."][0];
            NSString *name3 = [filename3 componentsSeparatedByString:@"."][0];

            NSString *path1 = [[FileUrl getCacheImageURL] stringByAppendingPathComponent:name1];
            NSString *path2 = [[FileUrl getCacheImageURL] stringByAppendingPathComponent:name2];
            NSString *path3 = [[FileUrl getCacheImageURL] stringByAppendingPathComponent:name3];

            if ([[NSFileManager defaultManager] fileExistsAtPath:path1]) {
                [_imageView1 setImage:[[UIImage alloc]initWithData:[NSData dataWithContentsOfFile:path1]]];
            }else{
                [_imageView1 setImageWithURL:[NSURL URLWithString:_model.img1] placeholderImage:LogoImage];
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:path2]) {
                [_imageView2 setImage:[[UIImage alloc]initWithData:[NSData dataWithContentsOfFile:path2]]];
            }else{
                [_imageView1 setImageWithURL:[NSURL URLWithString:_model.img1] placeholderImage:LogoImage];
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:path3]) {
                [_imageView3 setImage:[[UIImage alloc]initWithData:[NSData dataWithContentsOfFile:path3]]];
            }else{
                [_imageView3 setImageWithURL:[NSURL URLWithString:_model.img3] placeholderImage:LogoImage];
            }

        }else{
            [_imageView1 setImageWithURL:[NSURL URLWithString:_model.img1] placeholderImage:LogoImage];
            [_imageView2 setImageWithURL:[NSURL URLWithString:_model.img2] placeholderImage:LogoImage];
            [_imageView3 setImageWithURL:[NSURL URLWithString:_model.img3] placeholderImage:LogoImage];
        }

        
        //    //右上标(0:无 1：独家 2：原创 3：推荐)
        if ([_model.typeUp intValue] ==0 ) {
            _typeUpLabel.text = @"";
            [_typeUpLabel setHidden:YES];
        }else if ([_model.typeUp intValue]==1) {//专题
            [_typeUpLabel setHidden:NO];
            _typeUpLabel.text = @"独家";
        }else if ([_model.typeUp intValue]==2){ //图片
            [_typeUpLabel setHidden:NO];
            _typeUpLabel.text = @"原创";
        }else if ([_model.typeUp intValue]==3){//视频
            [_typeUpLabel setHidden:NO];
            _typeUpLabel.text = @"推荐";
        }

    }else{
        _titleLabel.hidden=NO;
        _contentLabel.hidden=NO;
        _typeLabel.hidden= NO;
        _typeUpLabel.hidden = NO;
        _imageView.hidden = NO;
        _imageTitleLabel.hidden = YES;
        _imageView1.hidden = YES;
        _imageView2.hidden = YES;
        _imageView3.hidden = YES;
        //    判断图片是否显示。确定titlelabel的point
        if (_model.img.length<2) {
            [self hiddenImage];
        }else{
            int brose = [[ThemeManager shareInstance]getBroseModel];
            if (brose ==1) {
                [self hiddenImage];
            }else{
                [self addImage];
                if([[DataCenter getConnectionAvailable] isEqualToString:@"none"]){
                    NSString *filename = [[_model.img componentsSeparatedByString:@"/"] lastObject];
                    NSString *name = [filename componentsSeparatedByString:@"."][0];
                    NSString *path = [[FileUrl getCacheImageURL] stringByAppendingPathComponent:name];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                        [_imageView setImage:[[UIImage alloc]initWithData:[NSData dataWithContentsOfFile:path]]];
                    }else{
                        [_imageView setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:LogoImage];
                    }
                }else{
                    [_imageView setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:LogoImage];

                }
                
            }
        }
        //    标题
        _titleLabel.text = _model.title;
        //    标题自动换行，行数为2则隐藏简介
        [_titleLabel sizeToFit];
        if (_titleLabel.height>20) {
            if (_titleLabel.height>40) {
                _titleLabel.height = 60;
            }else{
                _titleLabel.height = 40;
            }
            [_contentLabel setHidden:YES];
        }else{
            _titleLabel.height = 20;
            [_contentLabel setHidden:NO];
            //    内容
            _contentLabel.text = _model.newsAbstract;
            
        }
        
        if (_model.isselected==YES) {
            _titleLabel.colorName = kselectText;
        }else{
            _titleLabel.colorName = ktext;
        }
        //图片视图
        
        
        if ([_model.type intValue] ==0 ) {
            _typeLabel.text = @"";
            [_typeLabel setHidden:YES];
        }else if ([_model.type intValue]==1) {//专题
            [_typeLabel setHidden:NO];
            _typeLabel.text = @"专题";
        }else if ([_model.type intValue]==2){ //图片
            [_typeLabel setHidden:NO];
            _typeLabel.text = @"图集";
        }else if ([_model.type intValue]==3){//视频
            [_typeLabel setHidden:NO];
            _typeLabel.text = @"视频";
        }
        //    //右上标(0:无 1：独家 2：原创 3：推荐)
        if ([_model.typeUp intValue] ==0 ) {
            _typeUpLabel.text = @"";
            [_typeUpLabel setHidden:YES];
        }else if ([_model.typeUp intValue]==1) {//专题
            [_typeUpLabel setHidden:NO];
            _typeUpLabel.text = @"独家";
        }else if ([_model.typeUp intValue]==2){ //图片
            [_typeUpLabel setHidden:NO];
            _typeUpLabel.text = @"原创";
        }else if ([_model.typeUp intValue]==3){//视频
            [_typeUpLabel setHidden:NO];
            _typeUpLabel.text = @"推荐";
        }
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
    [super dealloc];
}

@end
