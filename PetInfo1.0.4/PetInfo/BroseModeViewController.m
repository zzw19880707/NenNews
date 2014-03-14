//
//  BroseModeViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BroseModeViewController.h"

@interface BroseModeViewController ()

@end

@implementation BroseModeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"图片浏览模式";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell  *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil]autorelease];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int broseMode = [userDefaults integerForKey:kbroseMode];
    if (broseMode ==indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"智能模式";
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.text = @"wifi网络下加载图片、标题及预览，3g或2g网络下只加载标题";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"加载标题";
        cell.detailTextLabel.text = @"所有网络下只加载标题";
    }
    else if(indexPath.row == 2)
    {
        cell.textLabel.text = @"加载全部";
        cell.detailTextLabel.text = @"所有网络下，加载图片、标题及预览";
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int mode = -1;
    if (indexPath.row == 0) {
        
        mode = 0;
    }
    else if (indexPath.row == 1)
    {
        
        mode = 1;
    }else if(indexPath.row == 2){
        
        mode = 2;
    }
    //    把浏览模式mode值存到本地
    [[NSUserDefaults standardUserDefaults]setInteger:mode forKey:kbroseMode];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.tableView reloadData];
    //    发送浏览模式变更通知
#warning  功能未实现
    [[NSNotificationCenter defaultCenter]postNotificationName:kBrownModelChangeNofication object:nil];
    
    //返回上一级菜单
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    }
    return 50;
}
@end
