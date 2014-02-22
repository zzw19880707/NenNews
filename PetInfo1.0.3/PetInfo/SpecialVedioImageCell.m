//
//  SpecialVedioImageCell.m
//  东北新闻网
//
//  Created by tenyea on 14-2-13.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "SpecialVedioImageCell.h"
#import "ColumnModel.h"
#import "Uifactory.h"
#import "ColumnModel.h"
#import "UIButton+WebCache.h"
#import "UIView+Additions.h"
#import "FMDatabase.h"
#import "FileUrl.h"
#import "NightModelContentViewController.h"
@implementation SpecialVedioImageCell
-(id)initWithData:(NSArray *)data andType :(int)type{
    self = [super init];
    if (self) {
        self.data = data;
        self.type = type;
        for (int i = 0 ; i < data.count; i++) {
            int j = i%2;
            UIButton *button =  [[UIButton alloc]initWithFrame:CGRectMake(20+j*150, 5+205*(i/2), 130, 170)];
            [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 1200 +i;
            [self.contentView addSubview:button];
            
//            NSString *text ;
//            if (type==3) {
//                text = @"视频";
//            }else if (type ==2){
//                text = @"图片";
//            } else{
//                text = @"";
//            }
//            if ([text isEqualToString:@""]) {
//                
//            }else{
//                UILabel *label = [[UILabel alloc]init];
//                label.text = text;
//                label.textColor = NenNewsTextColor;
//                label.backgroundColor = NenNewsgroundColor;
//                label.font = [UIFont systemFontOfSize:12];
//                label.frame = CGRectMake(130 - 30, 170-15, 30, 15);
//                label.textAlignment = NSTextAlignmentCenter;
//                [button addSubview:label];
//                [label release];
//            }
            
            UILabel *titleLabel =  [Uifactory createLabel:ktext];
            titleLabel.tag = 100+i;
            titleLabel.text =[NSString stringWithFormat: @"标题%d",i];
            titleLabel.frame = CGRectMake(20 +j*150, 180+205*(i/2), 130, 25);
            titleLabel.font = [UIFont systemFontOfSize:10];
            titleLabel.numberOfLines = 2;
            [self.contentView addSubview:titleLabel];
            [button release];
        }

        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    for (int i = 0 ; i < self.data.count; i++) {
        
        
        UIButton *button = (UIButton *)VIEWWITHTAG(self.contentView, 1200+i );
        button.hidden = NO;
        ColumnModel *model = [[ColumnModel alloc]initWithDataDic:_data[i]];
        [button setImageWithURL:[NSURL URLWithString:model.img] forState:UIControlStateNormal placeholderImage:LogoImage];
        UILabel *label = (UILabel *)VIEWWITHTAG(self.contentView, 100+i);
        label.hidden = NO;
        label.text = model.title;
        
    }
}
-(void)selectAction:(UIButton *)button{
    ColumnModel *model = [[ColumnModel alloc]initWithDataDic:_data[button.tag - 1200]];
    [self pushNewswithColumn:model];

}

-(void)pushNewswithColumn:(ColumnModel *)model {
    _po(model);
    //插入该cell已经选中
    NSString *newsId = model.newsId;
    NSString *newsAbstract =model.newsAbstract;
    NSString *img = model.img;
    NSString *sql = [NSString stringWithFormat:@"insert into columnData(newsId,title,newsAbstract,type,img,isselected) values('%@','%@','%@',%@,'%@',1) ;",newsId,model.title,newsAbstract,model.type,img];
    _po(sql);
    FMDatabase *db = [FileUrl getDB];
    [db open];
    NightModelContentViewController *nightModel = [[NightModelContentViewController alloc]init];
    
    [db executeUpdate:sql];
    [db close];
    nightModel.newsAbstract = model.newsAbstract;
    nightModel.type = [model.type intValue];
    nightModel.newsId = [NSString stringWithFormat:@"%@",model.newsId];
    nightModel.ImageUrl = model.img;
    [self.viewController.navigationController pushViewController:nightModel animated:YES];
    
}
@end
