//
//  VedioNightCell.m
//  东北新闻网
//
//  Created by 佐筱猪 on 14-2-9.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "VedioNightCell.h"
#import "UIButton+WebCache.h"
#import "Uifactory.h"
#import "VedioAndImageModel.h"
#import "ColumnModel.h"
@implementation VedioNightCell

-(id)initwithType :(int) type andData :(NSArray *)data andIndex :(int )index andSourceType:(int )sourceType{ //1:综合新闻 0:订阅
    self = [super init];
    if (self) {
        self.type = type;
        self.data = data;
        self.index = index;
        self.sourceType = sourceType;
        for (int i = 0 ; i <3; i++) {
            UIButton *button =  [[UIButton alloc]initWithFrame:CGRectMake(20+i*100, 5, 80, 60)];
            [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 1200 +i;
            [self.contentView addSubview:button];
            [button release];
            NSString *text ;
            if (type==3) {
                text = @"视频";
            }else if (type ==2){
                text = @"图集";
            } else{
                text = @"";
            }
            if ([text isEqualToString:@""]) {
                
            }else{
                UILabel *label = [[UILabel alloc]init];
                label.text = text;
                label.textColor = NenNewsTextColor;
                label.backgroundColor = NenNewsgroundColor;
                label.font = [UIFont systemFontOfSize:12];
                label.frame = CGRectMake(50, 50, 30, 15);
                label.textAlignment = NSTextAlignmentCenter;
                [button addSubview:label];
                [label release];
            }
            
            UILabel *titleLabel =  [Uifactory createLabel:ktext];
            titleLabel.tag = 100+i;
            titleLabel.frame = CGRectMake(20 +i*100, 70, 80, 20);
            titleLabel.font = [UIFont systemFontOfSize:8];
            titleLabel.numberOfLines = 2;
            [self.contentView addSubview:titleLabel];
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;

}

-(id)initwithType :(int) type andData :(NSArray *)data andIndex :(int )index{
    self = [self initwithType:type andData:data andIndex:index andSourceType:0];
    return self;
}
-(void)selectAction:(UIButton *)button{
    [self.eventDelegate selectedAction:(button.tag-1200) andIndex :_index];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    int count = _data.count;
    for ( int  i = 0 ; i < 3 ; i ++) {
        if (i < count) {
            UIButton *button = (UIButton *)VIEWWITHTAG(self.contentView, 1200+i );
            button.hidden = NO;
            if (_sourceType == 0) {//订阅
                VedioAndImageModel *model = _data[i];
                [button setImageWithURL:[NSURL URLWithString:model.videoPic] forState:UIControlStateNormal placeholderImage:LogoImage];
                UILabel *label = (UILabel *)VIEWWITHTAG(self.contentView, 100+i);
                label.hidden = NO;
                label.text = model.videoTitle;
            }else if (_sourceType == 1){
                ColumnModel *model = _data[i];
                [button setImageWithURL:[NSURL URLWithString:model.img1] forState:UIControlStateNormal placeholderImage:LogoImage];
                UILabel *label = (UILabel *)VIEWWITHTAG(self.contentView, 100+i);
                label.hidden = NO;
                label.text = model.title;

            }
            
        }else{
            UIButton *button = (UIButton *)VIEWWITHTAG(self.contentView, 1200+i);
            button.hidden = YES;
            UILabel *label = (UILabel *)VIEWWITHTAG(self.contentView, 100+i);
            label.hidden = YES;
        }
    }
}

@end
