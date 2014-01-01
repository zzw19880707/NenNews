//
//  NewsNightModelTableView.m
//  东北新闻网
//
//  Created by tenyea on 13-12-29.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "NewsNightModelTableView.h"
#import "ThemeManager.h"
#import "UIImageView+WebCache.h"
#import "ColumnModel.h"
#import "Uifactory.h"
#import "NightAndLoadingCell.h"
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
//    if (self.lastDate) {
//        
//    }
//    NSDate *_compareDate=[self.formatter dateFromString:_compareString];
//    NSTimeInterval time=[date timeIntervalSinceDate:_compareDate];
//    days=((int)time)/(3600*24);
//    return self.data.count;
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *listIndentifier=@"HomeDetailCell";
    NightAndLoadingCell *cell=[tableView  dequeueReusableCellWithIdentifier:listIndentifier];
    
    if (cell==nil) {//nib文件名
        cell = [[NightAndLoadingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listIndentifier];
        if (_imageData.count >0) {
            if (indexPath.row == 0) {
                XLCycleScrollView *csView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
                csView.delegate = self;
                csView.datasource = self;
                [csView.pageControl setHidden:YES];
                UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 135)];
                [view addSubview:csView];
                [csView release];
                
                self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, 150, 15 )];
                self.label.text = @"12312312313";
                self.label.textColor = [UIColor redColor];
                [view addSubview:self.label];
                [self.label release];
                
                self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(320 - 12*_imageData.count, 120, 12*_imageData.count, 15)];
                _pageControl.backgroundColor = [UIColor clearColor];
                self.pageControl.userInteractionEnabled = NO;
                self.pageControl.numberOfPages =_imageData.count  ;
                self.pageControl.currentPage= 0;
                [view addSubview:self.pageControl];
                
                view.backgroundColor = [UIColor blueColor];
                [cell.contentView addSubview:view];
                [view release];
                return cell;
            }else{
                ColumnModel *model =  self.data[indexPath.row];
                if (model.titlePic!=nil&&model.titlePic.length>0) {
                    
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 60)];
                    imageView.tag = 100;
                    [cell.contentView addSubview:imageView];
                    [imageView release];
                    
                    UILabel *titleLabel = [Uifactory createLabel:ktext];
                    titleLabel.frame = CGRectMake(100, 10, 320-100-20, 20);
                    titleLabel.tag = 101;
                    titleLabel.numberOfLines = 1;
                    [titleLabel setFont:[UIFont systemFontOfSize:16]];
                    [cell.contentView addSubview:titleLabel];
                    [titleLabel release];
                    
                    UILabel *contentLabel = [Uifactory createLabel:kselectText];
                    contentLabel.frame =CGRectMake(100, 80-20-10-10, 320-100-20, 30);
                    contentLabel.tag = 102;
                    contentLabel.numberOfLines = 2;
                    [contentLabel setFont:[UIFont systemFontOfSize:15]];
                    [cell.contentView addSubview:contentLabel];
                    [contentLabel release];
                }else{
                    UILabel *titleLabel = [Uifactory createLabel:ktext];
                    titleLabel.frame = CGRectMake(10, 10, 320-20, 20);
                    titleLabel.tag = 101;
                    titleLabel.numberOfLines = 1;
                    [titleLabel setFont:[UIFont systemFontOfSize:16]];
                    [cell.contentView addSubview:titleLabel];
                    [titleLabel release];
                    
                    UILabel *contentLabel = [Uifactory createLabel:kselectText];
                    contentLabel.frame =CGRectMake(10, 80-20-10-10, 320-20, 30);
                    contentLabel.tag = 102;
                    contentLabel.numberOfLines = 2;
                    [contentLabel setFont:[UIFont systemFontOfSize:15]];
                    [cell.contentView addSubview:contentLabel];
                    [contentLabel release];
                }
                
                
            }
        }else{
            ColumnModel *model =  self.data[indexPath.row];
            if (model.titlePic!=nil&&model.titlePic.length>0) {
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 60)];
                imageView.tag = 100;
                [cell.contentView addSubview:imageView];
                [imageView release];
                
                UILabel *titleLabel = [Uifactory createLabel:ktext];
                titleLabel.frame = CGRectMake(100, 10, 320-100-20, 20);
                titleLabel.tag = 101;
                titleLabel.numberOfLines = 1;
                [titleLabel setFont:[UIFont systemFontOfSize:16]];
                [cell.contentView addSubview:titleLabel];
                [titleLabel release];
                
                UILabel *contentLabel = [Uifactory createLabel:kselectText];
                contentLabel.frame =CGRectMake(100, 80-20-10-10, 320-100-20, 30);
                contentLabel.tag = 102;
                contentLabel.numberOfLines = 2;
                [contentLabel setFont:[UIFont systemFontOfSize:15]];
                [cell.contentView addSubview:contentLabel];
                [contentLabel release];
            }else{
                UILabel *titleLabel = [Uifactory createLabel:ktext];
                titleLabel.frame = CGRectMake(10, 10, 320-20, 20);
                titleLabel.tag = 101;
                titleLabel.numberOfLines = 1;
                [titleLabel setFont:[UIFont systemFontOfSize:16]];
                [cell.contentView addSubview:titleLabel];
                [titleLabel release];
                
                UILabel *contentLabel = [Uifactory createLabel:kselectText];
                contentLabel.frame =CGRectMake(10, 80-20-10-10, 320-20, 30);
                contentLabel.tag = 102;
                contentLabel.numberOfLines = 2;
                [contentLabel setFont:[UIFont systemFontOfSize:15]];
                [cell.contentView addSubview:contentLabel];
                [contentLabel release];
            }
        }

        
        ColumnModel *model =  self.data[indexPath.row];
        if (model.titlePic!=nil&&model.titlePic.length>0) {
            UIImageView *imageview = (UIImageView *)VIEWWITHTAG(cell.contentView, 100);
            [imageview setImageWithURL:[NSURL URLWithString:model.titlePic]];
        }
        UILabel *titleLabel = (UILabel *)VIEWWITHTAG(cell.contentView, 101);
        titleLabel.text = model.title;
        UILabel *contentLabel = (UILabel *)VIEWWITHTAG(cell.contentView, 102);
        contentLabel.text = model.summary;

    }
    
    return  cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_imageData.count >0) {
        if (indexPath.row ==0) {
            return 135;
        }else{
            return 80;
        }
    }
    return 80;
}
#pragma  mark XLCycleScrollViewDatasource
- (NSInteger)numberOfPages
{
    return [_imageData count];
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    UIImageView *imgaeView =[[[UIImageView alloc]init]autorelease];
    [imgaeView setImageWithURL:[NSURL URLWithString:[_imageData[index] objectForKey:@"imageURL"]]];
    imgaeView.frame =CGRectMake(0, 0, 320, 120);
    return imgaeView;
}

#pragma mark XLCycleScrollViewDelegate
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index
{
    [self.delegate ImageViewDidSelected:index andData:_imageData];
}
-(void)PageExchange:(NSInteger)index{
    _pageControl.currentPage = index;
    self.label.text = [_imageData[index] objectForKey:@"title"];
}

@end
