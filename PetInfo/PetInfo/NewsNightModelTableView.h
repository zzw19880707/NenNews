//
//  NewsNightModelTableView.h
//  东北新闻网
//
//  Created by tenyea on 13-12-29.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseTableView.h"
#import "XLCycleScrollView.h"

@protocol NewsNigthTabelViewDelegate <NSObject>

-(void)ImageViewDidSelected:(NSInteger)index andData:(NSMutableArray *)imageData;

@end
@interface NewsNightModelTableView : BaseTableView <XLCycleScrollViewDatasource,XLCycleScrollViewDelegate>


-(id)initwithColumnID:(int)columnID;
@property (nonatomic,retain) UIPageControl *pageControl;
@property (nonatomic,assign) int columnID;
@property (nonatomic,copy) NSDate *lastDate;
@property (nonatomic,retain) NSMutableArray *imageData;
@property (nonatomic,retain) UILabel *label ;

@property (nonatomic,assign) id<NewsNigthTabelViewDelegate> delegate;
@end
