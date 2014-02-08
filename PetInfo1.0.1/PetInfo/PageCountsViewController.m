//
//  PageCountsViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "PageCountsViewController.h"

@interface PageCountsViewController ()

@end

@implementation PageCountsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = @"每次加载条数";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int pageCounts = [userDefaults integerForKey:kpageCount];
    if (pageCounts ==indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"10";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"20";
    }else if (indexPath.row == 2) {
        cell.textLabel.text = @"30";
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int mode = -1;
    if (indexPath.row == 0)
    {
        
        mode = 0;
    }
    else if (indexPath.row == 1)
    {
        
        mode = 1;
    }else if(indexPath.row == 2)
    {
        
        mode = 2;
    }
//    把浏览模式mode值存到本地
    [[NSUserDefaults standardUserDefaults]setInteger:mode forKey:kpageCount];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //刷新图标
    [self.tableView reloadData];
    
    //    返回上一级菜单
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
