//
//  NewsNightModelTableView.m
//  东北新闻网
//
//  Created by tenyea on 13-12-29.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "NewsNightModelTableView.h"
#import "ThemeManager.h"
#import "Uifactory.h"
#import "NightAndLoadingCell.h"
#import "UIImageView+WebCache.h"
@implementation NewsNightModelTableView

-(id)init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
        self.isMore = YES;
        self.refreshHeader = YES;
    }
    return self;
}

-(id)initwithColumnID:(int)columnID{
    self = [self init];
    if (self) {
        self.columnID = columnID;
    }
    return self;
}
-(void)setBackgroundColor{
    self.backgroundColor = [[ThemeManager shareInstance]getBackgroundColor];
}

#pragma mark - NSNotification actions
- (void)NightModeChangeNotification:(NSNotification *)notification {
    //标题颜色，选中后标题颜色变为选中颜色，未选中为标题颜色
    [self setBackgroundColor];
}


#pragma mark ----datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_imageData.count>0) {
        return 2;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
//    if (self.lastDate) {
//        
//    }
//    NSDate *_compareDate=[self.formatter dateFromString:_compareString];
//    NSTimeInterval time=[date timeIntervalSinceDate:_compareDate];
//    days=((int)time)/(3600*24);

    if (_imageData.count>0&&section==0) {
            return 1;
    }else{
        return self.data.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_type == 1) {
        static NSString *pushIndentifier = @"PushIndentifier";
        UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:pushIndentifier];
        if (Cell == nil) {
            Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pushIndentifier];
        }
        Cell.textLabel.text =  [self.data[indexPath.row] objectForKey:@"title"];
        return Cell;

    }else{
        static NSString *listIndentifier=@"HomeDetailCell";
        static NSString *imageIndentifier=@"imageIndentifier";
        if (_imageData.count>0&&indexPath.section==0) {
            UITableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"imageIndentifier"];
            if (imageCell == nil) {
                imageCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageIndentifier];
                _csView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
                _csView.delegate = self;
                _csView.datasource = self;
                [_csView.pageControl setHidden:YES];
                UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 135)];
                [view addSubview:_csView];
                [_csView release];
                
                self.label = [Uifactory createLabel:ktext];
                self.label.frame = CGRectMake(0, 120, 200, 15 );
                self.label.text = [_imageData[0] objectForKey:@"pictureTitle"];
                self.label.font = [UIFont systemFontOfSize:12];
                [view addSubview:self.label];
                [self.label release];
                
                self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(320 - 12*_imageData.count-5, 120, 12*_imageData.count, 15)];
                _pageControl.backgroundColor = [UIColor clearColor];
                if (WXHLOSVersion()>=6.0) {
                    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
                    self.pageControl.currentPageIndicatorTintColor = NenNewsgroundColor;
                }
                self.pageControl.userInteractionEnabled = NO;
                self.pageControl.numberOfPages =_imageData.count  ;
                self.pageControl.currentPage= 0;
                [view addSubview:self.pageControl];
                
                [imageCell.contentView addSubview:view];
                [view release];
            }
            imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return imageCell;
            
        }else{
            
            NightAndLoadingCell *cell=[tableView  dequeueReusableCellWithIdentifier:listIndentifier];
            
            if (cell==nil) {//nib文件名
                
                cell = [[NightAndLoadingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listIndentifier];
            }
            ColumnModel *model =[self.data[indexPath.row ] retain];
            cell.model = model;
            return  cell;
            
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == 0) {
        if (_imageData.count >0&&indexPath.section==0) {
            return 135;
        }else{
            return 80;
        }
    }else{
        return 44;
    }
    
}
#pragma  mark XLCycleScrollViewDatasource
- (NSInteger)numberOfPages
{
    return [_imageData count];
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    UIImageView *imgaeView =[[[UIImageView alloc]init]autorelease];
    NSURL  *url = [NSURL URLWithString:[_imageData[index] objectForKey:@"pictureUrl"] ];
    [imgaeView setImageWithURL:url];
//    [imgaeView setImageWithURL:<#(NSURL *)#>]
    imgaeView.frame =CGRectMake(0, 0, 320, 120);
    return imgaeView;
}

#pragma mark XLCycleScrollViewDelegate
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index
{
    [self.changeDelegate ImageViewDidSelected:index andData:_imageData];
}
-(void)PageExchange:(NSInteger)index{
    _pageControl.currentPage = index;
    self.label.text = [_imageData[index] objectForKey:@"pictureTitle"];
}

-(void)reloadData{
    [super reloadData];
    [_csView reloadData];

}
@end
