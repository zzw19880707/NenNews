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
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FileUrl.h"
#import "UIImageView+WebCache.h"
@implementation NewsNightModelTableView

-(id)init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
        self.isMore = YES;
        
    }
    return self;
}
-(id)initWithData:(NSArray *)data type:(int)type{
    self = [self init];
    if (self) {
        self.data = data;
        self.type = type;
        self.refreshHeader = NO;

    }
    [self setBackgroundColor];

    return self;
}
-(id)initwithColumnID:(int)columnID{
    self = [self init];
    if (self) {
        self.columnID = columnID;
        self.refreshHeader = YES;
    }
    [self setBackgroundColor];

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
    if (_type ==2) {
        return 3;
    }
    if (_imageData.count>0) {
        return 2;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_type ==2) {
        return [self.data[section] count];
    }
    if (_imageData.count>0&&section==0) {
            return 1;
    }else{
        return self.data.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_type ==2) {
        if (section==0) {
            return @"今天";
        }else if(section==1){
            return @"昨天";
        }else{
            return @"更早";
        }
        
    }else{
        return @"";
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_type == 1)
    {
        static NSString *pushIndentifier = @"PushIndentifier";
        UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:pushIndentifier];
        if (Cell == nil) {
            Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pushIndentifier];
        }
        ColumnModel *model = self.data[indexPath.row];
        Cell.textLabel.text =  model.title;
        return Cell;

    }
    else if(_type ==2 )
    {
        static NSString *listIndentifier=@"HomeDetailCell";
        
        ColumnModel *model =self.data[indexPath.section][indexPath.row ] ;
        //            int newsId = [model.newsId intValue];
        int column = self.columnID;
        BOOL showImage = NO;
        if(column !=0){
            //            获取是否显示图片
            NSString *path = [FileUrl getDocumentsFile];
            NSString *columnshowName = [path stringByAppendingPathComponent:column_show_file_name];
            NSArray *arr = [[NSArray alloc]initWithContentsOfFile:columnshowName];
            for (int i = 0 ; arr.count ; i++) {
                NSDictionary *dic = arr[i];
                if ([[dic objectForKey:@"columnId"] intValue]==column) {
                    showImage = [[dic objectForKey:@"showimage"] boolValue];
                    break;
                }
            }

        }
        _po(model);
        int type = [model.type intValue];
        NightAndLoadingCell *cell=[tableView  dequeueReusableCellWithIdentifier:listIndentifier];
        
        if (cell==nil) {//nib文件名
            cell = [[NightAndLoadingCell alloc]initWithshoWImage:showImage type:type ];
        }
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return  cell;

    }
    else
    {
        static NSString *listIndentifier=@"HomeDetailCell";
        static NSString *imageIndentifier=@"imageIndentifier";
        if (_imageData.count>0&&indexPath.section==0) {
            UITableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"imageIndentifier"];
            if (imageCell == nil) {
                imageCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageIndentifier];
                self.csView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 135)];
                self.csView.delegate = self;
                self.csView.datasource = self;
                [self.csView.pageControl setHidden:YES];
                UIScrollView *view =[Uifactory createScrollView];
                view.frame  = CGRectMake(0, 0, 320, 135+15);
                [view addSubview:_csView];
                [_csView release];
                
                self.label = [Uifactory createLabel:ktext];
                self.label.frame = CGRectMake(10, 135, 200, 15 );
                self.label.text = [_imageData[0] objectForKey:@"pictureTitle"];
                self.label.font = [UIFont systemFontOfSize:12];
                [view addSubview:self.label];
                
                self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(320 - 12*_imageData.count-5, 120+15, 12*_imageData.count, 15)];
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
            }
            imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return imageCell;
            
        }
        else
        {

            ColumnModel *model =self.data[indexPath.row ] ;
//            int newsId = [model.newsId intValue];
            int column = self.columnID;
            BOOL showImage = NO;
//            获取是否显示图片
            NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:show_column];
            for (int i = 0 ; arr.count ; i++) {
                NSDictionary *dic = arr[i];
                if ([[dic objectForKey:@"columnId"] intValue]==column) {
                    showImage = [[dic objectForKey:@"showimage"] boolValue];
                    break;
                }
            }
            int type = [model.type intValue];
            NightAndLoadingCell *cell=[tableView  dequeueReusableCellWithIdentifier:listIndentifier];
            
            if (cell==nil) {//nib文件名
                cell = [[NightAndLoadingCell alloc]initWithshoWImage:showImage type:type ];
            }
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.showImage = showImage;
            return  cell;
            
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == 0) {
        if (_imageData.count >0&&indexPath.section==0) {
            return 150;
        }else{
            ColumnModel *model = self.data[indexPath.row];
            if (model.img1.length>2&&model.img2.length>2&&model.img3.length>2) {
                return 110;
            }
            return 80;
        }
    }else{
        return 80;
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
    imgaeView.frame =CGRectMake(0, 0, 320, 135);
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
//    if (_csView !=nil) {
//        [_csView reloadData];
//    }

}
@end
