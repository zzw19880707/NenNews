//
//  SpecialNightViewController.m
//  东北新闻网
//
//  Created by tenyea on 14-1-25.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "SpecialNightViewController.h"
#import "ThemeManager.h"
#import "SpecialNightModelTableView.h"
#import "NightModelContentViewController.h"
#import "ColumnModel.h"
#import "FMDatabase.h"
#import "FileUrl.h"
@interface SpecialNightViewController ()

@end

@implementation SpecialNightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showHUD:INFO_RequestNetWork isDim:YES];
    self.view.backgroundColor = [[ThemeManager shareInstance] getBackgroundColor];
    _SpecialTableView = [[SpecialNightModelTableView alloc] init];
    _SpecialTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-26);
    _SpecialTableView.eventDelegate = self;
    [self.view addSubview:_SpecialTableView];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.newsId forKey:@"subjectId"];
    
    [DataService requestWithURL:URL_getThematic_List andparams:params andhttpMethod:@"GET" completeBlock:^(id result) {
        if ((NSNull *)result == [NSNull null]) {
            [self hideHUD];
            [self showHUD:INFO_ERROR isDim:YES];
            [self performSelector:@selector(hideHUD) withObject:nil afterDelay:1];
            return ;
        }else{//加载正常
            NSDictionary *newsDic = [result objectForKey:@"news"];
            NSString *newsabstract = [result objectForKey:@"news_abstract"];
            NSArray *newsDataArray = [result objectForKey:@"news_data"];
            _SpecialTableView.abstract = newsabstract;
            _SpecialTableView.ImgData = newsDic;
            _SpecialTableView.data = newsDataArray;
            [_SpecialTableView reloadData];
            [self performSelector:@selector(hideHUD) withObject:nil afterDelay:.5];
        }

    } andErrorBlock:^(NSError *error) {
        [self performSelector:@selector(hideHUD) withObject:nil afterDelay:.5];
    }];
}
#pragma mark  UItableviewEventDelegate
//下拉
-(void)pullDown:(BaseTableView *)tableView{
    
}
-(void)tableView:(SpecialNightModelTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row == 0 &&![[tableView.ImgData objectForKey:@"newsimg"] isEqualToString:@""]) {//图片
            
            if ([[tableView.ImgData objectForKey:@"newsid"]isEqualToString:@""]) {
//                纯图片 无操作
            }else{
                NightModelContentViewController *nightModel = [[NightModelContentViewController alloc]init];
                nightModel.type = [[tableView.ImgData objectForKey:@"newstype"] intValue];
                nightModel.newsId = [tableView.ImgData objectForKey:@"newsid"];
                nightModel.titleLabel = [tableView.ImgData objectForKey:@"newstitle"];
                [self.navigationController pushViewController:nightModel animated:YES];
            }
        }else{
//         导语 无操作
        }
    }else{
        NSDictionary *modeldic =tableView.data[indexPath.section-1] ;
        int type = [[modeldic objectForKey:@"subject_type" ] intValue];

        if (type ==0) {//综合新闻
            ColumnModel *model =[[ColumnModel alloc]initWithDataDic:[tableView.data[indexPath.section-1] objectForKey:@"subject_news"][indexPath.row] ];
            [self pushNewswithColumn:model];
        }else{//图片和视频
            
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)pushNewswithColumn:(ColumnModel *)model {
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    if (viewControllers.count > 2) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    _po(model);
    //插入该cell已经选中
    NSString *newsId = model.newsId;
    NSString *newsAbstract =model.newsAbstract;
    NSString *img = model.img;
    NSString *sql = [NSString stringWithFormat:@"insert into columnData(newsId,title,newsAbstract,type,img,isselected) values('%@','%@','%@',%@,'%@',1) ;",newsId,model.title,newsAbstract,model.type,img];
    _po(sql);
    FMDatabase *db = [FileUrl getDB];
    [db open];
        NightModelContentViewController *nightModel = [[NightModelContentViewController alloc]init];
    
        [db executeUpdate:sql];
    [db close];
        nightModel.newsAbstract = model.newsAbstract;
        nightModel.type = [model.type intValue];
        nightModel.newsId = [NSString stringWithFormat:@"%@",model.newsId];
        nightModel.ImageUrl = model.img;
        [self.navigationController pushViewController:nightModel animated:YES];
  
}
#pragma mark 内存管理
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
