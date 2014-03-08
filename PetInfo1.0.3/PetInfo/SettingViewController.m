//
//  SettingViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"
#import "ThemeManager.h"
#import "BroseModeViewController.h"
#import "PageCountsViewController.h"
#import "FileUrl.h"
#import "ASIFormDataRequest.h"

@interface SettingViewController (){
    UIAlertView *_alert;
}
@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //setting
        NSString *settingPath = [[FileUrl getDocumentsFile]  stringByAppendingPathComponent: kSetting_file_name];
        _settingDic = [[NSMutableDictionary alloc] initWithContentsOfFile: settingPath];
        self.title = @"设置";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [_tableView reloadData];
//    [self viewWillAppear:animated];
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"阅读设置";
            break;
            
        case 1:
            return @"订阅设置";
            break;
            
        case 2:
            return @"缓存控制";
            break;
            
        case 3:
            return @"产品信息";
            break;
            
        default:
            break;
    }
    return @"Demo";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return 3;
    }
    if (section ==3) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[[UITableViewCell alloc] init] autorelease];
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    switch (section)
    {
        case 0:
            switch (row)
        {
            case 0:
                cell.textLabel.text = @"字体大小";

                NSArray *segments = [NSArray arrayWithObjects:@"小", @"中", @"大", nil];
                UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems: segments];
                [segmented addTarget: self action: @selector(fontSizeValueChanged:) forControlEvents: UIControlEventValueChanged];
                if (WXHLOSVersion()>=7.0) {
                    segmented.frame = CGRectMake(cell.frame.size.width - segmented.frame.size.width-30, 5, segmented.frame.size.width+20, segmented.frame.size.height+10);
                }else{
                    segmented.frame = CGRectMake(cell.frame.size.width - segmented.frame.size.width-30, 5, segmented.frame.size.width, segmented.frame.size.height);
                }
                
                [cell.contentView addSubview: segmented];

                [segmented setSelectedSegmentIndex: [[_settingDic objectForKey: kFont_Size] intValue]];

                [segmented release];

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 1:
                cell.textLabel.text = @"新闻加载模式";
                
                [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];

                break;
            case 2:
                cell.textLabel.text = @"每次加载条数";
                [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
                break;
        }
            break;
            
        case 1:
            switch (row)
        {
                case 0:
                cell.textLabel.text = @"消息推送";

                UISwitch *sw = [[UISwitch alloc] init];
                [sw addTarget: self action: @selector(newsPushValueChanged:) forControlEvents: UIControlEventValueChanged];
                sw.frame = CGRectMake(cell.frame.size.width - sw.frame.size.width - 25, (cell.frame.size.height - sw.frame.size.height) / 2, cell.frame.size.width, cell.frame.size.height);
                [cell.contentView addSubview: sw];

                if (1 == [[_settingDic objectForKey: KNews_Push] intValue])
                {
                    [sw setOn: YES];
                }
                else
                {
                    [sw setOn: NO];
                }

                [sw release];

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                break;

                default:
                break;

        }
            break;
            
        case 2:
            switch (row)
        {
            case 0:
                cell.textLabel.text = @"清除缓存";

                UILabel *cacheSizeLabel = [[UILabel alloc] init];
                
                NSUInteger cacheSize = [[DataCenter sharedCenter] cacheSize];
                if (cacheSize < 1024)
                {
                    cacheSizeLabel.text = [NSString stringWithFormat: @"%u B", cacheSize];
                }
                else if (cacheSize < 1024 * 1024)
                {
                    cacheSizeLabel.text = [NSString stringWithFormat: @"%.2f KB", (cacheSize * 1.0f) / 1024];
                }
                else if (cacheSize < 1024 * 1024 * 1024)
                {
                    cacheSizeLabel.text = [NSString stringWithFormat: @"%.2f MB", (cacheSize * 1.0f) / (1024 * 1024)];
                }
                else
                {
                    cacheSizeLabel.text = [NSString stringWithFormat: @"%.2f GB", (cacheSize * 1.0f) / (1024 * 1024 * 1024)];
                }
                cacheSizeLabel.frame = CGRectMake(ScreenWidth - 120, 0, 100, 40);
                cacheSizeLabel.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview: cacheSizeLabel];
                
                [cacheSizeLabel release];
                
                break;
        }
            break;
            
        case 3:
         
            switch (row)
        {
            case 1:
                cell.textLabel.text = @"给我评分";
                break;
            case 0:
                cell.textLabel.text = @"检查更新";
                break;
            case 2:
                cell.textLabel.text = @"关于";
                [cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
                break;
        }
        default:
            break;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate methods


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }
    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if ([indexPath section] ==0) {
        if ([indexPath row] ==1) {
            BroseModeViewController *broseModeViewController = [[BroseModeViewController alloc] init];
            [self.navigationController pushViewController: broseModeViewController animated: YES];
            [broseModeViewController release];
        }
        if ([indexPath row] == 2) {
            PageCountsViewController *pageCounts = [[PageCountsViewController alloc]init];
            [self.navigationController pushViewController: pageCounts animated: YES];
            [pageCounts release];
        }
    }
    if ([indexPath section] == 2)
    {
        [[DataCenter sharedCenter] cleanCache];
        [tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
    }
    if ([indexPath section] == 3)
    {
        if (indexPath.row ==1) {
            //跳转到应用页面
//            NSString* urlStr1 = [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%d",itunesappid];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr1]];
            
            //跳转到评价页面
//            NSString *urlStr2 = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id;=%d", itunesappid ];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr2]];
            
//            if (WXHLOSVersion() >=7.0) {
                NSString *str = [NSString stringWithFormat:
                                 
                                 @"itms-apps://itunes.apple.com/app/id%d",itunesappid];
//                @"http://itunes.apple.com/us/app/%E4%B8%9C%E5%8C%97%E6%96%B0%E9%97%BB%E7%BD%91/id802739994?ls=1&mt=8"
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//            }else{
//                NSString *str = [NSString stringWithFormat:
//                                 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
//                                 itunesappid ];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//            }
            
        }else if (indexPath.row ==0){
            
            //弹出提示
            
            if (_alert ==nil) {
                _alert = [[UIAlertView alloc]initWithTitle:@"正在检查更新"
                                                   message:nil
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:nil];
                _alert.tag = 100;
                if (WXHLOSVersion()<7.0) {
                    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                    activeView.center = CGPointMake(_alert.bounds.size.width/2.0f, _alert.bounds.size.height-40.0f);
                    [activeView startAnimating];
                    [_alert addSubview:activeView];
                    [activeView release];
                }
            }
            [_alert show];
//            访问网络
            NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%d",itunesappid];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
            [request setTimeOutSeconds:30];
            [request setRequestMethod:@"GET"];
            [request setCompletionBlock:^{
                BOOL  isnew = NO;
//                取消提示框
                [_alert dismissWithClickedButtonIndex:0 animated:YES];
                if (request.responseStatusCode == 200)
                {
                    NSDictionary *infoDict   = [[NSBundle mainBundle]infoDictionary];
                    NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
                    NSDictionary *jsonData   = [NSJSONSerialization JSONObjectWithData:request.responseData  options:NSJSONReadingMutableContainers error:nil];
                    NSArray      *infoArray  = [jsonData objectForKey:@"results"];
                    
                    if (infoArray.count >= 1)
                    {
                        NSDictionary *releaseInfo   = [infoArray objectAtIndex:0];
                        NSString     *latestVersion = [releaseInfo objectForKey:@"version"];
                        NSString     *releaseNotes  = [releaseInfo objectForKey:@"releaseNotes"];
                        NSString     *title         = [NSString stringWithFormat:@"%@%@版本", @"东北新闻网", latestVersion];
                        self.updateURL = [releaseInfo objectForKey:@"trackViewUrl"];
                        if ([latestVersion compare:currentVersion] == NSOrderedDescending){
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:releaseNotes delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"去App Store下载", nil];
                            [alertView show];
                            [alertView release];
                        }else{
                            isnew = YES;
                        }
                        
                    }else{
                        isnew = YES;
                    }
                    
                }else{
                    isnew = YES;

                }
                
                if (isnew) {
                    alertContent(INFO_ISNEWVersion);
                }
            }];
            [request startSynchronous];



        }
        else if(indexPath.row==2){
            AboutViewController *aboutViewController = [[AboutViewController alloc] init];
            [self.navigationController pushViewController: aboutViewController animated: YES];
            [aboutViewController release];
        }

    }
}


#pragma mark - Private methods
- (void)fontSizeValueChanged:(id)aObject;
{
    UISegmentedControl *segmented = (UISegmentedControl*)aObject;
    
    [_settingDic setValue: [NSNumber numberWithInt: segmented.selectedSegmentIndex] forKey: kFont_Size];
    [self saveSetting];

//    [[NSNotificationCenter defaultCenter]postNotificationName:kFontSizeChangeNofication object:nil];
    

}

- (void)newsPushValueChanged:(id)aObject
{
    UISwitch *sw = (UISwitch*)aObject;
    
    [_settingDic setValue: [NSNumber numberWithBool: sw.on] forKey: KNews_Push];
    
    [self saveSetting];
    [[ThemeManager shareInstance]setPush];
}

- (void)saveSetting
{
    NSString *settingPath = [[FileUrl getDocumentsFile] stringByAppendingPathComponent: kSetting_file_name];
    [_settingDic writeToFile: settingPath atomically: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark alertViewDelegage
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updateURL]];
    }
}
- (void)dealloc {
    [_settingDic release];
    [_tableView release];
    [_alert release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    _alert = nil;
    [super viewDidUnload];
}
@end
