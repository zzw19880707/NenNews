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

@implementation VedioNightCell

-(id)initwithType :(int) type{
    self = [super init];
    if (self) {
        self.type = type;
        for (int i = 0 ; i <3; i++) {
            UIButton *button =  [[UIButton alloc]initWithFrame:CGRectMake(20+i*100, 5, 80, 60)];
            button.backgroundColor = [UIColor redColor];
            [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [self.contentView addSubview:button];
            [button release];
            NSString *text ;
            if (type==0) {
                text = @"视频";
            }else if (type ==1){
                text = @"图片";
            } else{
                text = @"";
            }
            if ([text isEqualToString:@""]) {
                
            }else{
                UILabel *label = [[UILabel alloc]init];
                label.text = text;
                label.backgroundColor = NenNewsgroundColor;
                label.font = [UIFont systemFontOfSize:10];
                label.frame = CGRectMake(50, 50, 30, 10);
                label.textAlignment = NSTextAlignmentCenter;
                [button addSubview:label];
                [label release];
            }
            
            UILabel *titleLabel =  [Uifactory createLabel:ktext];
            titleLabel.tag = 100+i;
            titleLabel.frame = CGRectMake(20 +i*100, 70, 80, 10);
            [self.contentView addSubview:titleLabel];
            [titleLabel release];
        }
    }
    return self;
}
-(void)selectAction:(UIButton *)button{
    if (_type == 0) {
        
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    int count = _data.count;
    for ( int  i = 0 ; i < 3 ; i ++) {
        if (i < count) {
            UIButton *button = (UIButton *)VIEWWITHTAG(self.contentView, i);
            button.hidden = NO;
            VedioAndImageModel *model = _data[i];
            [button setImageWithURL:[NSURL URLWithString:model.videoPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo_80x60.png"]];
            UILabel *label = (UILabel *)VIEWWITHTAG(self.contentView, 100+i);
            label.hidden = NO;
            label.text = model.videoTitle;
            
        }else{
            UIButton *button = (UIButton *)VIEWWITHTAG(self.contentView, i);
            button.hidden = YES;
            UILabel *label = (UILabel *)VIEWWITHTAG(self.contentView, 100+i);
            label.hidden = YES;
        }
    }
}

@end
