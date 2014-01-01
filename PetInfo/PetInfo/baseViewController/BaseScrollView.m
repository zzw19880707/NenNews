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
@implementation BaseScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andButtons:(NSArray *) buttons andContents:(NSArray *) contents{
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentSize = CGSizeMake(ScreenWidth+2, ScreenHeight);
//        self.contentInset = UIEdgeInsetsMake(0, 10, 0, 0);
        self.buttonsArray = buttons;
        self.contentsArray = contents;
        //用于分割线
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor =[UIColor grayColor];
        bgView.frame = CGRectMake(0, 0, frame.size.width, 40);
    
        _sliderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+15, 30, 30, 10)];
        
        _sliderImageView.image = [UIImage imageNamed:@"navigationbar_background.png"];
        
        _buttonBgView = [Uifactory createScrollView];
        _buttonBgView.frame =CGRectMake(0, 0, frame.size.width- 40, 39);
        [_buttonBgView addSubview:_sliderImageView];

//        _buttonBgView.backgroundColor = NenNewsgroundColor;
        _buttonBgView.contentSize =CGSizeMake( 70*buttons.count, 38);
        _buttonBgView.showsHorizontalScrollIndicator = NO;
        _buttonBgView.showsVerticalScrollIndicator = NO;
        _buttonBgView.bounces = NO;
        _buttonBgView.tag =10000;
        for (int i = 0; i<buttons.count ; i++) {
            UIButton *button = (UIButton *)buttons[i];
            [button addTarget: self  action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            button.tag = 1000+i;
            [_buttonBgView addSubview:button];
            [button release];
        }
        
        UIView *addButtonView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - 40, 0, 40, 39)];
        addButtonView.backgroundColor = NenNewsTextColor;
        UIButton *addButton = [[UIButton alloc]init];
        [addButton setImage:[UIImage imageNamed:@"title_button_add.png"] forState:UIControlStateNormal];
        addButton.frame =CGRectMake(0, 0, 40, 40);
        [addButton addTarget:self action:@selector(addcolumn) forControlEvents:UIControlEventTouchUpInside];
        [addButtonView addSubview:addButton];
        [bgView addSubview:addButtonView];
        [addButton  release];
        [addButtonView release];
    
        [bgView addSubview:_buttonBgView];
        [self addSubview:bgView];
        [bgView release];
        
        _contentBgView = [Uifactory createScrollView];
        _contentBgView.frame =CGRectMake(0, 40, frame.size.width+20, frame.size.height - 40);
        _contentBgView.tag =10001;
        _contentBgView.pagingEnabled =YES;
        _contentBgView.delegate = self;
        _contentBgView.showsHorizontalScrollIndicator=NO;
        _contentBgView.showsVerticalScrollIndicator=NO;
        _contentBgView.contentSize = CGSizeMake(340*buttons.count, frame.size.height-40);
        _contentBgView.bounces = NO;
        int _tx = 0 ;
        for (int i = 0;i<contents.count ; i++) {
            
            UIScrollView *labelscroll = [[UIScrollView alloc]init];
            labelscroll.frame = CGRectMake(340 *i, 0, _contentBgView.width, _contentBgView.height);
            UIView *view =(UIView *)contents[i];
            labelscroll.contentSize = view.size;
            [labelscroll addSubview:view];
            [_contentBgView addSubview:labelscroll];
            _tx +=340;
        }
        [self addSubview:_contentBgView];
        
    }
    return self;
}

//通过按钮名称初始化
-(id)initwithButtons:(NSArray *)buttonsName WithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.buttonsArray = @[@""];
//        self.contentsArray = @[@""];
        //用于分割线
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor =[UIColor grayColor];
        bgView.frame = CGRectMake(0, 0, frame.size.width, 40);

        
//        滚动条
        _sliderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+15, 30, 30, 10)];
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
        [addButtonView release];
//        添加阴影图片
        UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"baseScrollview_title_background.png"]];
        shadowImageView.frame = CGRectMake(ScreenWidth-42, 0, 2, 39);
        [bgView addSubview:shadowImageView];
        [bgView addSubview:_buttonBgView];
        [self addSubview:bgView];
        [bgView release];
//      初始化content内容图
        _contentBgView = [Uifactory createScrollView];
        _contentBgView.frame =CGRectMake(0, 40, frame.size.width+20, frame.size.height - 40);
        _contentBgView.tag =10001;
        _contentBgView.pagingEnabled =YES;
        _contentBgView.delegate = self;
        _contentBgView.showsHorizontalScrollIndicator=NO;
        _contentBgView.showsVerticalScrollIndicator=NO;
        _contentBgView.bounces = NO;

        [self addSubview:_contentBgView];

        self.buttonsNameArray =buttonsName;
    }
    return self;
}

//刷新该title及内容数据
-(void)reloadButtonsAndViews{
    _buttonBgView.contentSize =CGSizeMake( 70*_buttonsNameArray.count, 38);
    _contentBgView.contentSize = CGSizeMake(340*_buttonsNameArray.count, self.frame.size.height-40);
        for (UIView *view in [_buttonBgView subviews]) {
            if ((UIImageView *)view ==_sliderImageView) {
                continue;
            }
            [view removeFromSuperview];
        }

//初始化按钮
    for (int i = 0; i<_buttonsNameArray.count ; i++) {
        int columnId = [[_buttonsNameArray[i] objectForKey:@"cloumID"] intValue];
        UIButton *button = [Uifactory createButton:[_buttonsNameArray[i] objectForKey:@"name"]];
        button.frame =  CGRectMake(10 + 70*i, 0, 60, 30);
        [button addTarget: self  action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.tag = 1000+ i;
        [_buttonBgView addSubview:button];
        
        
        
        NewsNightModelTableView *newsTableView = [[NewsNightModelTableView alloc]initwithColumnID:columnId];
        newsTableView.frame = CGRectMake(340 *i, 0, ScreenWidth, ScreenHeight -40);
        newsTableView.eventDelegate = self;
        
        
        
        
        NSMutableDictionary *d = [[NSMutableDictionary alloc]initWithContentsOfFile:[[FileUrl getDocumentsFile]stringByAppendingPathComponent:data_file_name]];
        
        newsTableView.data = [d objectForKey:@"1"];
        newsTableView.imageData = [d objectForKey:@"imageData"];
        newsTableView.delegate = self;
        [_contentBgView addSubview:newsTableView];
        
//        UIScrollView *labelscroll = [[UIScrollView alloc]init];
//        labelscroll.frame = CGRectMake(340 *i, 0, _contentBgView.width, _contentBgView.height);
//        labelscroll.contentSize = newsTableView.size;
//        [labelscroll addSubview:newsTableView];
//        [_contentBgView addSubview:labelscroll];


    }
    
//滑动条返回至第一个
#warning 滑动条返回至第一个
    
    
    
    
    

}

#pragma mark UIScrollViewEventDelegate
-(void)ImageViewDidSelected:(NSInteger)index andData:(NSMutableArray *)imageData{
    
    if (index>0) {
        NightModelContentViewController *nightModel = [[NightModelContentViewController alloc]init];
        nightModel.titleID = [[imageData[index] objectForKey:@"titleID"] intValue];
        [self.eventDelegate pushViewController:nightModel];
    }else{
        WebViewController *webView = [[WebViewController alloc]initWithUrl:[imageData[index] objectForKey:@"contentURL"]];
        [self.eventDelegate pushViewController:webView];
    }
}
#pragma mark UItableviewEventDelegate
//上拉刷新
-(void)pullDown:(NewsNightModelTableView *)tableView{

    //    参数
    NSMutableDictionary *params  = [[NSMutableDictionary alloc]init];
    int count = [[NSUserDefaults standardUserDefaults]integerForKey:kpageCount];
    NSNumber *number = [NSNumber numberWithInt:(count*10)];
    [params setValue:number forKey:@"count"];
    int columnID=tableView.columnID;
    [params setValue:[NSNumber numberWithInt:columnID] forKey:@"columnID"];
    int sinceID = [[tableView.data[0] objectForKey:@"titleID"] intValue];
    [params setValue:[NSNumber numberWithInt:sinceID] forKey:@"sinceId"];
    //    [params setValue:<#(id)#> forKey:@"maxId"];
    
    [DataService requestWithURL:URL_getColumn_List andparams:params andhttpMethod:@"POST" completeBlock:^(id result) {
        NSArray *array =  [result objectForKey:@"data"];
        NSMutableArray *listData = [[NSMutableArray alloc]init];
        
        for (ColumnModel * model  in array) {
            [listData addObject:model];
        }
        tableView.data =listData;
        [tableView reloadData];
        [tableView doneLoadingTableViewData];

    } andErrorBlock:^(NSError *error) {
        [tableView doneLoadingTableViewData];
        
    }];

}
//下拉加载
-(void)pullUp:(NewsNightModelTableView *)tableView{
    
    //    参数
    NSMutableDictionary *params  = [[NSMutableDictionary alloc]init];
    int count = [[NSUserDefaults standardUserDefaults]integerForKey:kpageCount];
    NSNumber *number = [NSNumber numberWithInt:(count*10)];
    [params setValue:number forKey:@"count"];
    int columnID=tableView.columnID;
    [params setValue:[NSNumber numberWithInt:columnID] forKey:@"columnID"];
    int sinceID = [[tableView.data[0] objectForKey:@"titleID"] intValue];
    [params setValue:[NSNumber numberWithInt:sinceID] forKey:@"sinceId"];
    //    [params setValue:<#(id)#> forKey:@"maxId"];
    
    [DataService requestWithURL:URL_getColumn_List andparams:params andhttpMethod:@"POST" completeBlock:^(id result) {
        NSArray *array =  [result objectForKey:@"data"];
        NSMutableArray *listData = [[NSMutableArray alloc]init];
        
        for (ColumnModel * model  in array) {
            [listData addObject:model];
        }
        [tableView doneLoadingTableViewData];
        [listData addObjectsFromArray:tableView.data];
        
        tableView.data  = listData;
        [tableView reloadData];
    } andErrorBlock:^(NSError *error) {
        [tableView doneLoadingTableViewData];
        
    }];
    
}
-(void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NightModelContentViewController *nightModel = [[NightModelContentViewController alloc]init];
    ColumnModel *model =tableView.data[indexPath.row];
    nightModel.titleID = [model.titleID intValue];
    [self.eventDelegate pushViewController:nightModel];
}

//#pragma mark asiRequest
//-(void)requestFailed:(ASIHTTPRequest *)request{
//    
//}
//-(void)requestFinished:(id)result{
//    
//}
-(void)setButtonsNameArray:(NSArray *)buttonsNameArray{
    if (_buttonsNameArray !=buttonsNameArray) {
        [_buttonsNameArray release];
        _buttonsNameArray = [buttonsNameArray copy];

    }
    [self reloadButtonsAndViews];

}
#pragma mark 按钮事件
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
}

-(void)addcolumn{
    [self.eventDelegate addButtonAction];
}

#pragma mark ScrollDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = _contentBgView.contentOffset.x/340;
    
    CGPoint point = [_sliderImageView convertPoint:CGPointMake(0, 0) fromView:[UIApplication sharedApplication].keyWindow ];

    int  count =self.buttonsArray.count;
    if (count==0) {
        count = self.buttonsNameArray.count;
    }
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
    
    
    switch (scrollView.tag) {
        case 10000:
            break;
        case 10001:
            break;
        default:
            break;
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

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.x ==0) {
        [self.eventDelegate showLeftMenu];
    }
    if (scrollView.contentOffset.x==scrollView.contentSize.width -340) {
        [self.eventDelegate showRightMenu];
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
