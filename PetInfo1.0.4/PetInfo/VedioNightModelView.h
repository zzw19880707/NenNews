//
//  VedioNightModelView.h
//  东北新闻网
//
//  Created by tenyea on 14-2-8.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//
#import "VedioAndImageModel.h"
#import "ColumnModel.h"
@protocol VedioNightModelViewDelegate <NSObject>
-(void)selectedAction:(VedioAndImageModel *)model;
-(void)selectedColumnAction:(ColumnModel *)model;

@end
#import "BaseTableView.h"
#import "VedioNightCell.h"
@interface VedioNightModelView : BaseTableView <VedioandImageDelegate>{
    float _height;
    float _width;
}
//初始化
-(id)initwithData:(NSArray *)data;
-(id)initwithsourceType:(int )sourceType;
@property (nonatomic,assign) int columnID;

@property (nonatomic,assign) int type;//类型 3:视频 2:图片
@property (nonatomic,assign) id<VedioNightModelViewDelegate> VedioDelegate;


@property (nonatomic,assign) int sourceType; //1:综合新闻 0:订阅
@end
