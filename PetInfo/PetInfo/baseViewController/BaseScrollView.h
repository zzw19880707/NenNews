//
//  BaseScrollView.h
//  PetInfo
//
//  Created by 佐筱猪 on 13-12-15.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsNightModelTableView.h"
#import "BaseViewController.h"
@protocol UIScrollViewEventDelegate <NSObject>
@optional
//add按钮事件
-(void)addButtonAction;
-(void)showLeftMenu;
-(void)showRightMenu;
-(void)setEnableGesture:(BOOL)b;
-(void)autoRefreshData:(NewsNightModelTableView *)tableView;
//-(void)pushViewController:(BaseViewController *)baseViewController;
@end
@interface BaseScrollView : UIScrollView <UIScrollViewDelegate>{
    UIScrollView *_buttonBgView;
    UIScrollView *_contentBgView;
    UIImageView *_sliderImageView;
    BOOL _isRight;
}
//button宽70 ，frame（10+70*i,0,60,30）
//content
//-(id)initWithFrame:(CGRect)frame andButtons:(NSArray *) buttons andContents:(NSArray *) contents;
//通过按钮名称初始化

-(id)initwithButtons:(NSArray *)buttonsName WithFrame:(CGRect)frame;

//刷新该title及内容数据
-(void)reloadButtonsAndViews;
@property (nonatomic,retain) NSArray *buttonsArray;
@property (nonatomic,retain) NSArray *contentsArray;
@property (nonatomic,retain) NSArray *buttonsNameArray;
@property (nonatomic,assign) id<UIScrollViewEventDelegate> eventDelegate;
@end
