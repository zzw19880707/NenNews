//
//  LeftViewController.m
//  东北新闻网
//
//  Created by 佐筱猪 on 13-12-18.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "LeftViewController.h"
#import "RootViewController.h"
#import "PushNewsViewController.h"
#import "CollectionViewController.h"
#import "BaseNavViewController.h"
@interface LeftViewController ()

@end

@implementation LeftViewController

@synthesize imageArray = _imageArray;
@synthesize nameArray =_nameArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//初始化背景图
-(void)_initFrame{

    UIImageView *background = [[UIImageView alloc]init];
    background.frame = CGRectMake( 0, 0, ScreenWidth, ScreenHeight);
    [background setImage:[UIImage imageNamed:@"right_background_view.png"]];
    background.tag =1010;
    [self.view addSubview:background];
    [background release];

    UIView *backview =[[UIView alloc]init];
    backview.backgroundColor = [UIColor blackColor];
    backview.frame = CGRectMake( 0, 0, ScreenWidth, ScreenHeight);
    backview.alpha = 0.2;
    [self.view addSubview:backview];
    [backview release];
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 40, 150, ScreenHeight-80);
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = CLEARCOLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    self.nameArray = @[@"  新  闻  ",@"推送资讯",@"我的收藏"];
    self.imageArray = @[@"left_news.png",@"left_push_news.png",@"left_ collect_news.png"];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initFrame];
//    默认选中第一条
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_imageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *leftcell = @"leftcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftcell];
    if (cell == Nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LeftCell" owner:self options:nil] lastObject];
    }
    UIImageView *imageVIew = (UIImageView *)[cell.contentView viewWithTag:200];
    [imageVIew setImage:[UIImage imageNamed:_imageArray[indexPath.row]]];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:210];
    label.text = _nameArray[indexPath.row];
    label.font = FONT(20);
    label.textColor = [UIColor whiteColor];
    //ios7适配
    if (WXHLOSVersion()>=7.0) {
        cell.backgroundColor = CLEARCOLOR;
    }else{
        cell.contentView.backgroundColor = CLEARCOLOR;

    }
    //设置选中时颜色
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor = COLOR(14, 110, 184);
    //设置选中状态
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
#pragma mark uitabledelegate
//选中修改mainviewcontroller 显示内容
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    BaseViewController *baseView ;
    if (indexPath.row==0) {
        baseView = [[RootViewController alloc]init];
    } else if( indexPath.row ==1){
        baseView = [[PushNewsViewController alloc]init];
    }else {
        baseView = [[CollectionViewController alloc]init];
    }
    
    BaseNavViewController *navViewController = [[BaseNavViewController alloc]initWithRootViewController:baseView];
    self.appDelegate.menuCtrl.rootViewController = navViewController;
    [self.appDelegate.menuCtrl showRootController:YES];

    [baseView release];
}

#pragma mark 内存管理
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}
- (void)viewDidUnload {

    [super viewDidUnload];
}

@end
