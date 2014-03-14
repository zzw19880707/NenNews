//
//  SpecialVedioImageCell.h
//  东北新闻网
//
//  Created by tenyea on 14-2-13.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "BaseNightModelCell.h"

@interface SpecialVedioImageCell : BaseNightModelCell

-(id)initWithData:(NSArray *)data andType :(int)type;
@property (nonatomic,assign) int type ;
@property (nonatomic,retain) NSArray *data;

@end
