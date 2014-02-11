//
//  ColumnTabelViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-24.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "ColumnTabelViewController.h"
#import "FileUrl.h"
#import "DataCenter.h"
#import "FMDB/src/FMDatabase.h"
#import "ColumnModel.h"
@interface ColumnTabelViewController ()

@end

@implementation ColumnTabelViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}
-(id)initWithType :(int)type{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}
-(void)_initcolumnname {
    //写入初始化文件
    if (_type ==0) {
        _showNameArray = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:show_column]];
        _addNameArray = [[NSMutableArray alloc]initWithArray:[DataCenter getShowColumn:0 andSubscribe:NO]];
    }else{
        _showNameArray = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:subscribe_column]];
        _addNameArray = [[NSMutableArray alloc]initWithArray:[DataCenter getShowColumn:0 andSubscribe:YES]];

    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UILabel *titlelabel=[[UILabel alloc]initWithFrame:CGRectZero];
    titlelabel.font=[UIFont boldSystemFontOfSize:18.0f];
    titlelabel.backgroundColor= NenNewsgroundColor;
    titlelabel.text=@"栏目编辑";
    titlelabel.textColor=NenNewsTextColor;
    [titlelabel sizeToFit];
    self.navigationItem.titleView = [titlelabel autorelease];

    [self _initcolumnname];
    
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor = NenNewsgroundColor;
    //        [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"navagiton_back.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 30);
    //        button.showsTouchWhenHighlighted = YES;
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = [backItem autorelease];
    

    self.editing = YES;
    // Uncomment the following line to preserve selection between presentations.
//     self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillDisappear:(BOOL)animated{
    if (_type == 0) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setValue:_showNameArray forKey:show_column];
        [self.eventDelegate columnChanged:_showNameArray];
        [user synchronize];
    }else{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setValue:_showNameArray forKey:subscribe_column];
        [self.eventDelegate columnChanged:_showNameArray];
        [user synchronize];

    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark ----按钮事件

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_showNameArray count];
    }else if(section == 1){
        return [_addNameArray count];
    }
    
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"显示";
            break;
            
        case 1:
            return @"更多";
            break;
            
        default:
            break;
    }
    return @"Demo";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *columnIdentifier = @"columnIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:columnIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:columnIdentifier] autorelease];
    }
    switch (indexPath.section) {
        case 0:
            
            cell.textLabel.text = [_showNameArray[indexPath.row]objectForKey:@"name"];
            break;
        case 1:
            cell.textLabel.text = [_addNameArray[indexPath.row]objectForKey:@"name" ];

            break;
        default:
            break;
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 &&indexPath.row == 0 ) {
        return NO;
    }
    return YES;
}


#pragma mark - Table view delegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return UITableViewCellEditingStyleNone;
        }
        return UITableViewCellEditingStyleDelete;
    }else if (indexPath.section == 1) {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleNone;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = [[_showNameArray objectAtIndex:indexPath.row] retain];
        [_showNameArray removeObject:dic];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_addNameArray addObject:dic];
        
        FMDatabase *db = [FileUrl getDB];
        [db open];
        [db executeUpdate:[NSString stringWithFormat:@"update columnList set isshow = 0 where column=%@",[dic objectForKey:@"columnId"]]];
        [db close];
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:_addNameArray.count-1 inSection:1];
        [tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
        [dic release];

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSDictionary *dic = [[_addNameArray objectAtIndex:indexPath.row] retain];
        [_addNameArray removeObject:dic];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_showNameArray addObject:dic];
        FMDatabase *db = [FileUrl getDB];
        [db open];
        [db executeUpdate:[NSString stringWithFormat:@"update columnList set isshow = 1 where column=%@",[dic objectForKey:@"columnId"]]];
        [db close];
        NSIndexPath *index = [NSIndexPath indexPathForRow:_showNameArray.count-1 inSection:0];
        [tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
        [dic release];
    }
}



// Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
     if (toIndexPath.section ==0 &&toIndexPath.row ==0) {
         [self.tableView reloadData];

         return;
     }
     FMDatabase *db = [FileUrl getDB];
     [db open];
     
     if (fromIndexPath.section>toIndexPath.section) {
         NSDictionary *dic = [[_addNameArray objectAtIndex:fromIndexPath.row] retain] ;
         [db executeUpdate:[NSString stringWithFormat:@"update columnList set isshow = 1 where column=%@",[dic objectForKey:@"columnId"]]];
         [_addNameArray removeObject:dic];
         [_showNameArray insertObject:dic atIndex:toIndexPath.row];
         [dic release];

     }
     if (toIndexPath.section>fromIndexPath.section) {
         NSDictionary *dic = [[_showNameArray objectAtIndex:fromIndexPath.row] retain] ;
         [db executeUpdate:[NSString stringWithFormat:@"update columnList set isshow = 0 where column=%@",[dic objectForKey:@"columnId"]]];
         [_showNameArray removeObject:dic];
         [_addNameArray insertObject:dic atIndex:toIndexPath.row];
         [dic release];
         _pn(dic.retainCount);
     }
     if (toIndexPath.section == fromIndexPath.section) {
         if (fromIndexPath.section==0) {
             [_showNameArray exchangeObjectAtIndex:toIndexPath.row withObjectAtIndex:fromIndexPath.row ];
         }else{
             [_addNameArray exchangeObjectAtIndex:toIndexPath.row withObjectAtIndex:fromIndexPath.row];
         }
     }
     [db close];
     [self.tableView reloadData];
 } // 移动结束调用


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
