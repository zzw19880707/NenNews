//
//  VedioNightModelView.h
//  东北新闻网
//
//  Created by tenyea on 14-2-8.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "BaseTableView.h"

@interface VedioNightModelView : BaseTableView{
    float _height;
    float _width;
    NSArray *_data;
}
//初始化
-(id)initwithData:(NSArray *)data;

@property (nonatomic,assign) int type;//类型 0:视频 1:图片
@end
