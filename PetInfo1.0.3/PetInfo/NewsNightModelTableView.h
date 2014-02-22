//
//  NewsNightModelTableView.h
//  东北新闻网
//
//  Created by tenyea on 13-12-29.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseTableView.h"
#import "XLCycleScrollView.h"
#import "ColumnModel.h"
@protocol NewsNigthTabelViewDelegate <NSObject>

-(void)ImageViewDidSelected:(NSInteger)index andData:(NSArray *)imageData;

@end
@interface NewsNightModelTableView : BaseTableView <XLCycleScrollViewDatasource,XLCycleScrollViewDelegate>{
    
}

-(id)initWithData:(NSArray *)data type:(int)type;
-(id)initwithColumnID:(int)columnID;
@property (nonatomic,assign) int type;//0:rootview  1:collectionview 2:pushview
@property (nonatomic,retain) UIPageControl *pageControl;
@property (nonatomic,assign) int columnID;
@property (nonatomic,retain) NSArray *imageData;
@property (nonatomic,retain) UILabel *label ;
@property (nonatomic,retain) XLCycleScrollView *csView ;
@property (nonatomic,assign) id<NewsNigthTabelViewDelegate> changeDelegate;
@end
