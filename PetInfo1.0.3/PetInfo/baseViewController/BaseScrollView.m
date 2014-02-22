//
//  BaseScrollView.m
//  PetInfo
//
//  Created by 佐筱猪 on 13-12-15.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseScrollView.h"
#import "Uifactory.h"
#import "ColumnModel.h"
#import "NewsNightModelTableView.h"
#import "FileUrl.h"
#import "WebViewController.h"
#import "NightModelContentViewController.h"
#import "ThemeManager.h"
#import "BaseTableView.h"
@implementation BaseScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//通过按钮名称初始化
-(id)initwithButtons:(NSArray *)buttonsName WithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        //用于分割线
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor =[UIColor grayColor];
        bgView.frame = CGRectMake(0, 0, frame.size.width, 40);
        
        
        //        滚动条
        _sliderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+15, 30, 30, 5)];
        _sliderImageView.image = [UIImage imageNamed:@"navigationbar_background.png"];
        
        //        scrollerView
        _buttonBgView = [Uifactory createScrollView];
        _buttonBgView.frame =CGRectMake(0, 0, frame.size.width- 42, 39);
        [_buttonBgView addSubview:_sliderImageView];
        _buttonBgView.showsHorizontalScrollIndicator = NO;
        _buttonBgView.showsVerticalScrollIndicator = NO;
        _buttonBgView.bounces = NO;
        _buttonBgView.tag =10000;
        
        
        //        add按钮
        UIView *addButtonView =[Uifactory createScrollView];
        addButtonView.frame =CGRectMake(ScreenWidth - 40, 0, 40, 39);
        //        addButtonView.backgroundColor = NenNewsTextColor;
        UIButton *addButton = [[UIButton alloc]init];
        [addButton setImage:[UIImage imageNamed:@"title_button_add.png"] forState:UIControlStateNormal];
        addButton.frame =CGRectMake(0, 0, 40, 40);
        [addButton addTarget:self action:@selector(addcolumn) forControlEvents:UIControlEventTouchUpInside];
        [addButtonView addSubview:addButton];
        [bgView addSubview:addButtonView];
        [addButton  release];
        //        添加阴影图片
        UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"baseScrollview_title_background.png"]];
        shadowImageView.frame = CGRectMake(ScreenWidth-42, 0, 2, 39);
        [bgView addSubview:shadowImageView];
        [bgView addSubview:_buttonBgView];
        [self addSubview:bgView];
        [bgView release];
        //      初始化content内容图
        _contentBgView = [Uifactory createScrollView];
        _contentBgView.frame =CGRectMake(0, 40, frame.size.width+20, self.bounds.size.height - 40);
        _contentBgView.tag =10001;
        _contentBgView.pagingEnabled =YES;
        _contentBgView.delegate = self;
        _contentBgView.showsHorizontalScrollIndicator=NO;
        _contentBgView.showsVerticalScrollIndicator=NO;
        _contentBgView.bounces = NO;
        
        [self addSubview:_contentBgView];
        
        self.buttonsNameArray =buttonsName;
        
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kDescriptionImage]) {
            
            UIView *backview = [[UIView alloc]init];
            backview.tag = 8063;
            backview.frame = CGRectMake(0, -15, ScreenWidth, ScreenHeight+15);
            backview.backgroundColor = [UIColor grayColor];
            backview.alpha = 0.9;
            [self addSubview:backview];
//            [backview release];
            UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"description.png"]];
            background.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            [backview addSubview:background];
            [background release];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismisdesc:)];
            tap.delaysTouchesBegan = YES;
            [backview addGestureRecognizer:tap];
            [tap release];
            AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;

            [appDelegate.window addSubview:backview];
        }
       

    }
    return self;
}

//刷新该title及内容数据
-(void)reloadButtonsAndViews{
    _buttonsArray = _buttonsNameArray[0];
    _contentsArray = _buttonsNameArray[1];
    _buttonBgView.contentSize =CGSizeMake( 70*_buttonsArray.count, 38);
    _contentBgView.contentSize = CGSizeMake(340*_buttonsArray.count, self.bounds.size.height - 44-20-40);
    for (UIView *view in [_buttonBgView subviews]) {
        if ((UIImageView *)view ==_sliderImageView) {
            continue;
        }
        [view removeFromSuperview];
    }
    
    for (UIView *view in [_contentBgView subviews]) {
        [view removeFromSuperview];
    }
    for (int i = 0 ; i< _buttonsArray.count; i ++) {
        UIButton *button  =(UIButton *) _buttonsArray[i];
        [button addTarget: self  action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonBgView addSubview:button];
        [button release];
//        if ([_contentsArray[i] isKindOfClass:[NewsNightModelTableView class]]) {
            BaseTableView *newsTableView = _contentsArray[i];
            newsTableView.tag = 1300+i;
            [_contentBgView addSubview:newsTableView];
            [newsTableView release];
//        }
        
    }
    
    //滑动条返回至第一个
    _contentBgView.contentOffset = CGPointMake(0, 0) ;
    _buttonBgView.contentOffset = CGPointMake(0, 0);
    
}



-(void)setButtonsNameArray:(NSArray *)buttonsNameArray{
    if (_buttonsNameArray !=buttonsNameArray) {
        [_buttonsNameArray release];
        _buttonsNameArray = [buttonsNameArray copy];
    }
    [self reloadButtonsAndViews];
}
#pragma mark 按钮事件
-(void)dismisdesc:(UIGestureRecognizer *)tap{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    UIView *back =(UIView *) [appDelegate.window viewWithTag:8063];
    [back removeFromSuperview];
    back = nil;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDescriptionImage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)selectAction:(UIButton *)button{
    int page = button.tag -1000;
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint spoint = _sliderImageView.origin;
        spoint.x = 10+15+page *70;
        _sliderImageView.origin = spoint;
    }];
    CGPoint point = _contentBgView.contentOffset;
    point.x = page *340;
    _contentBgView.contentOffset = point;
    
        if ([_contentsArray[0] isKindOfClass:[NewsNightModelTableView class]]) {
            [self showData];

        }
    

    
}
//显示数据。根据时间来判断是否刷新
-(void)showData {
//    获取当前view
    NewsNightModelTableView *table= (NewsNightModelTableView *)VIEWWITHTAG(_contentBgView, 1300+_contentBgView.contentOffset.x /340);
    //    获取当前时间
    NSDate *nowDate = [NSDate date];
    //    获取上次时间+20分钟
    NSDate *lastDate = [table.lastDate dateByAddingTimeInterval:loaddata_date];
    if (table.lastDate ==nil) {
        [table autoRefreshData];
        [self.eventDelegate autoRefreshData:table];

    }else{
        if (nowDate ==[lastDate laterDate:nowDate]) {
            [table autoRefreshData];
            [self.eventDelegate autoRefreshData:table];
        }
    }
    
}
-(void)addcolumn{
    [self.eventDelegate addButtonAction];
}

#pragma mark ScrollDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _beginX =_contentBgView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_contentBgView.contentSize.width/340<4) {
        if ([_contentsArray[0] isKindOfClass:[NewsNightModelTableView class]]) {

            if (_beginX !=_contentBgView.contentOffset.x) {
                [self showData];
                
            }
        }
        return ;
    }
    int page = _contentBgView.contentOffset.x/340;
    
    CGPoint point = [_sliderImageView convertPoint:CGPointMake(0, 0) fromView:[UIApplication sharedApplication].keyWindow ];
    
    int  count  = self.buttonsArray.count;
    
    if (_isRight) {
        
    }else{
        //向右平移
        if (page<count-1) {
            if (70+70-point.x>self.frame.size.width-50) {
                CGPoint cpoint = _buttonBgView.contentOffset;
                cpoint.x += 140 -(self.frame.size.width-50+point.x)-25;
                [_buttonBgView setContentOffset:cpoint animated:YES];
            }
        }else if(page == count -1){
            if (70+70-point.x>self.frame.size.width-50) {
                CGPoint cpoint = _buttonBgView.contentOffset;
                cpoint.x += 140 -(self.frame.size.width-50+point.x)-25-70;
                [_buttonBgView setContentOffset:cpoint animated:YES];
            }
        }
    }
    
    //向左平移
    if (page>0) {
        if (-point.x-70<0) {
            CGPoint cpoint = _buttonBgView.contentOffset;
            cpoint.x -=70 +point.x+25;
            [_buttonBgView setContentOffset:cpoint animated:YES];
        }
    }else if (page == 0){
        if (-point.x-70<0) {
            [_buttonBgView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    if ([_contentsArray[0] isKindOfClass:[NewsNightModelTableView class]]) {
        if (_beginX !=_contentBgView.contentOffset.x) {
            [self showData];

        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.tag ==10001) {
        CGPoint point = _sliderImageView.origin;
        point=CGPointMake(scrollView.contentOffset.x /340 *70 +25, point.y);
        _sliderImageView.origin = point;
        
    }
    
}
//滑动结束
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if (scrollView.contentOffset.x ==0) {
        [self.eventDelegate setEnableGesture:YES];
        [self.eventDelegate showLeftMenu];
    }else if (scrollView.contentOffset.x==scrollView.contentSize.width -340) {
        [self.eventDelegate setEnableGesture:YES];
//        最右标识。  最右时不滚动
        _isRight = YES;
        [self.eventDelegate showRightMenu];
    }else{
        [self.eventDelegate setEnableGesture:NO];
        _isRight = NO;
    }
    
    
    
}
-(void)dealloc{
    RELEASE_SAFELY(_buttonsArray);
    RELEASE_SAFELY(_contentBgView);
    RELEASE_SAFELY(_buttonBgView);
    RELEASE_SAFELY(_contentsArray);
    RELEASE_SAFELY(_sliderImageView);
    [super dealloc];
}
@end
