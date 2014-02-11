//
//  VedioNightCell.h
//  东北新闻网
//
//  Created by 佐筱猪 on 14-2-9.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

@protocol VedioandImageDelegate <NSObject>

-(void)selectedAction:(int) i andIndex :(int)index;

@end
#import "BaseNightModelCell.h"
@interface VedioNightCell : BaseNightModelCell
-(id)initwithType :(int) type andData :(NSArray *)data andIndex :(int )index;//0 视频 1 图片
@property (nonatomic,assign) id<VedioandImageDelegate> eventDelegate;
@property (nonatomic,retain) NSArray *data;
@property (nonatomic,assign) int type ;
@property (nonatomic,assign) int index;//用于计算位置的索引
@end
