//
//  ColumnViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-21.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "ColumnViewController.h"
#define columnwidth 70
#define columnheight 30
#import "FileUrl.h"

#define column_off_y 40
//tag值为 第几个*100 +columnid
@interface ColumnViewController ()

@end

@implementation ColumnViewController
@synthesize showNameArray =_showNameArray;
@synthesize addNameArray =_addNameArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"编辑栏目";
    }
    return self;
}
//取上整数
-(int)division:(int) i count:(int)b{
    return  (i%b ==0 )?(i/b) : (i/b + 1);
    
}
-(void)_initcolumnname {
//    //写入初始化文件
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *plistPath1 = [paths objectAtIndex:0];
//    NSString *pathName = [plistPath1 stringByAppendingPathComponent:column_show_file_name];
//    _columnNameArray = [[NSArray alloc]initWithContentsOfFile:pathName];
//    _showNameArray = [[NSMutableArray alloc]init];
//    _addNameArray = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i < _columnNameArray.count ; i++) {
        NSDictionary *dic = _columnNameArray[i];
        if ([[dic objectForKey:@"isShow"] boolValue]) {
            [_showNameArray addObject:dic];
            
        }else{
            [_addNameArray addObject:dic];
        }
        [dic release];
    }

}

//初始化位置数组
-(void)_initLocationArray {
    _LocationArray = [[NSMutableArray alloc]init];
    int width = 5;
    int height = column_off_y;
    int count = _columnNameArray.count;
    for (int i = 0 ; i<count; i++) {
        CGRect frame = CGRectMake(0+width, height, columnwidth, columnheight);
        [_LocationArray addObject:[NSValue valueWithCGRect:frame]];
        if (i%4 == 3) {
            height +=column_off_y ;
            width = 5;
        }else{
            width += columnwidth+10;
        }
    }
}
//初始化button
-(void)_initButton {
    _po([_addNameArray[0] objectForKey:@"name"]);

    //初始化显示的按钮
    for (int i = 0 ; i< _showNameArray.count ; i++) {
        NSDictionary *dic = _showNameArray[i];
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i*100 +[[dic objectForKey:@"columid"] intValue];
        button.frame = [_LocationArray[i] CGRectValue];
        button.backgroundColor = [UIColor grayColor];
        if(i==0){
//            button.userInteractionEnabled=YES;
            button.enabled = NO;
        }
        //单击，增加到不显示的最后一位
        [button addTarget:self action:@selector(subbutton:) forControlEvents:UIControlEventTouchUpInside];
        //移动
        [button addTarget:self action:@selector(dragMoving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
//        [button addTarget:self action:@selector(dragEnded:withEvent: ) forControlEvents: UIControlEventTouchDragOutside];
        [self.view  addSubview:button];
        [button release];
    }
    int addHeight = [self division:_showNameArray.count count:4] * column_off_y + column_off_y +10;//栏数 *栏高 +初始化高度 +10
    //初始化不显示的view
    _addBackgroundView = [[UIView alloc]init];
    _addBackgroundView.frame = CGRectMake(0, addHeight , ScreenWidth, ScreenHeight - addHeight);
    _addBackgroundView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_addBackgroundView];
    //初始化显示的按钮
    for (int i = 0 ; i< _addNameArray.count ; i++) {
        NSDictionary *dic = _addNameArray[i];
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i*100 +[[dic objectForKey:@"columid"] intValue];
        button.frame = [_LocationArray[i] CGRectValue];
        button.backgroundColor = [UIColor whiteColor];
        //单击，增加到不显示的最后一位
        [button addTarget:self action:@selector(subcolumn:) forControlEvents:UIControlEventTouchUpInside];
        //移动
        [button addTarget:self action:@selector(dragMoving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
//        [button addTarget:self action:@selector(dragEnded:withEvent: ) forControlEvents: UIControlEventTouchDragExit];
        [_addBackgroundView addSubview:button];
        [button release];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initcolumnname];
    [self _initLocationArray];
    [self _initButton];
//    _po([_addNameArray[0] objectForKey:@"name"]);

}

#pragma mark 按钮事件
//显示的栏目--->不显示
-(void)subbutton:(UIButton *)subbutton{
    int seatid = _addNameArray.count +1;
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:subbutton.titleLabel.text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.tag = seatid *100 + subbutton.tag%100;
    button.frame = [_LocationArray[seatid-1] CGRectValue];
    button.backgroundColor = [UIColor whiteColor];
    //单击，增加到不显示的最后一位
    [button addTarget:self action:@selector(subcolumn:) forControlEvents:UIControlEventTouchUpInside];
    //移动
    [button addTarget:self action:@selector(dragMoving:withEvent:) forControlEvents:UIControlEventTouchDragInside];

    button.alpha = 0;
    [_addBackgroundView addSubview:button];
    CGRect frame = button.frame;
    if (_isviewchange) {
        button.frame = _toFrame;
        int column = [self isBCenterOnOherView:button];
        button.frame = [_LocationArray[column] CGRectValue];
        [self refreshButtonTagadd:column];
    }else{
        frame.origin.y +=_addBackgroundView.top;

    }
    
    
    int removeid = subbutton.tag / 100 ;
    DLogRect(subbutton.frame);
    [UIView animateWithDuration:.5 animations:^{
        subbutton.frame = frame;
        DLogRect(subbutton.frame);

        button.alpha = 1;
        
    } completion:^(BOOL finished) {
        [subbutton removeFromSuperview];
    }];
    
    [self refreshButtonTag:removeid];
}
- (void) dragMoving: (UIButton *) c withEvent:ev
{
//    NSLog(@"Button  moving ..............");

    _toFrame = [c convertRect:CGRectMake(0,0, columnwidth, columnheight) toView:_addBackgroundView];
    DLogRect(_toFrame);
    
    if (_toFrame.origin.y<0) {
        _isviewchange = NO;
    }else{
        _isviewchange = YES;
    }
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
    
}



-(void)subcolumn:(UIButton *)button {
    
}
-(void) refreshButtonTagadd:(int) addid{
    [UIView animateWithDuration:0.2 animations:^{
        for (int i = 0 ; i<_addNameArray.count ; i++) {
            NSDictionary *dic =  _addNameArray[i];
            if (i>addid) {
                
            }else if(i ==addid ){
                UIButton *button =(UIButton *)[self.view viewWithTag:i*100 +[[dic objectForKey:@"columid"] intValue]];
                button.frame = [_LocationArray[button.tag/100+1] CGRectValue];
                button.tag +=100;
            }else{
                
            }
        }

    } completion:^(BOOL finished) {
        
    }];
}
-(void) refreshButtonTag:(int) removeid{
    //button 位移
    [UIView animateWithDuration:0.2 animations:^{
        for (int i = 0 ; i<_showNameArray.count ; i++) {
            NSDictionary *dic =  _showNameArray[i];
            if (i>removeid) {
                UIButton *button =(UIButton *)[self.view viewWithTag:i*100 +[[dic objectForKey:@"columid"] intValue]];
                button.frame = [_LocationArray[button.tag/100-1] CGRectValue];
                button.tag -=100;
            }else if(i ==removeid ){
                
            }else{
                
            }
        }
        
    } completion:^(BOOL finished) {
        NSDictionary *dic =  _showNameArray[removeid];
        [_addNameArray addObject:dic ];
        [_showNameArray removeObject:dic];
    }];
    
    //灰色背景位移
    int count = _showNameArray.count-1;
    if (count%4 ==0) {
        int i=count/4;
        [UIView animateWithDuration:0.3 animations:^{
            _addBackgroundView.top -= (2-i)*column_off_y;
            _addBackgroundView.height +=(2-i)*column_off_y;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    
    

}

//判断button的中心点是否在一个button上  如果在，则返回位置
-(int)isBCenterOnOherView:(UIButton *)button {
    int changeid = -1;
    CGPoint centerPoint= button.center;
    int tr = (centerPoint.x-5)/columnwidth ;
    int td = (centerPoint.y -column_off_y )/columnheight;
    changeid = tr+td*4;
    if (changeid >_addNameArray.count) {
        changeid =_addNameArray.count +1;
    }
    return changeid;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
