//
//  VedioNightCell.h
//  东北新闻网
//
//  Created by 佐筱猪 on 14-2-9.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

//@protocol VedioandImageDelegate <NSObject>
//
//-(void)selectedAction:(int) i;
//
//@end
#import "BaseNightModelCell.h"
@interface VedioNightCell : BaseNightModelCell
-(id)initwithType :(int) type;//0 视频 1 图片
//@property (nonatomic,assign) id<VedioandImageDelegate> eventDelegate;
@property (nonatomic,retain) NSArray *data;
@property (nonatomic,assign) int type ;
@end
