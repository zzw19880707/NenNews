//
//  VedioNightModelView.h
//  东北新闻网
//
//  Created by tenyea on 14-2-8.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//
#import "VedioAndImageModel.h"

@protocol VedioNightModelViewDelegate <NSObject>
-(void)selectedAction:(VedioAndImageModel *)model;
@end
#import "BaseTableView.h"
#import "VedioNightCell.h"
@interface VedioNightModelView : BaseTableView <VedioandImageDelegate>{
    float _height;
    float _width;
}
//初始化
-(id)initwithData:(NSArray *)data;
@property (nonatomic,assign) int columnID;

@property (nonatomic,assign) int type;//类型 3:视频 2:图片
@property (nonatomic,assign) id<VedioNightModelViewDelegate> VedioDelegate;
@end
