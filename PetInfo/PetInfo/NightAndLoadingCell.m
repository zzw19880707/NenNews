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
@implementation NightAndLoadingCell



-(id)init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BrownModelChangeNotification:) name:kBrownModelChangeNofication object:nil];
    }
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BrownModelChangeNotification:) name:kBrownModelChangeNofication object:nil];
        [self _initView];
    }
    return self;
}


-(void)_initView {
//图片视图
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 60)];
    _imageView.backgroundColor = CLEARCOLOR;
    [self.contentView addSubview:_imageView];
//    标题
    _titleLabel = [Uifactory createLabel:ktext];
    _titleLabel.frame = CGRectMake(100, 10, 320-100-20, 20);
    _titleLabel.numberOfLines = 1;
    [_titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:_titleLabel];
//     摘要
    _contentLabel = [Uifactory createLabel:kselectText];
    _contentLabel.frame =CGRectMake(100, 80-20-10-10, 320-100-20, 30);
    _contentLabel.numberOfLines = 2;
    [_contentLabel setFont:[UIFont systemFontOfSize:10]];
    [self.contentView addSubview:_contentLabel];
    
    
    

}
//layoutSubviews展示数据，子视图布局
-(void)layoutSubviews{
    [super layoutSubviews];

    int type = [_model.type intValue] ;
    UILabel *typeLabel = [[UILabel alloc]init];
    typeLabel.frame = CGRectMake(320 - 40, 60, 40, 20);
    typeLabel.font = [UIFont systemFontOfSize:12];
    typeLabel.textColor = NenNewsTextColor;
    typeLabel.backgroundColor = NenNewsgroundColor;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    if (type ==0 ) {
        typeLabel.backgroundColor = CLEARCOLOR;
        typeLabel.text = @"";
    }else if (type ==1) {//专题
        typeLabel.text = @"专题";
    }else if (type==2){ //图片
        typeLabel.text = @"图集";
    }else if (type==3){//视频
        typeLabel.text = @"视频";
    }

    [self.contentView addSubview:typeLabel];
    [typeLabel release];

    //图片视图
    if (![_model.img isEqualToString:@"0"]&&![_model.img isEqualToString:@"imgList"]) {
        [_imageView setImageWithURL:[NSURL URLWithString:_model.img]];
    }else {
        _titleLabel.frame = CGRectMake(10, 10, 300, 20);
        _contentLabel.frame = CGRectMake(10, 40, 300, 30);
        [_imageView setHidden:YES];
    }

//    标题
    _titleLabel.text = _model.title;
//    内容
    _contentLabel.text = _model.newsAbstract;

}

-(void)setModel:(ColumnModel *)model{
    if (_model != model) {
        [_model  release];
        _model = model;
    }
#warning <#message#>
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
 
}

#define mark Notification 
#pragma mark - NSNotification actions
- (void)NightModeChangeNotification:(NSNotification *)notification {
    //标题颜色，选中后标题颜色变为选中颜色，未选中为标题颜色
//    [self setBackgroundColor];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_imageView release];
    [super dealloc];
}

@end
