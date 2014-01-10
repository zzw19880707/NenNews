//
//  ColumnTabelViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-24.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "ColumnTabelViewController.h"
#import "FileUrl.h"
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
-(void)_initcolumnname {
    //写入初始化文件
    
    NSString *pathName = [[FileUrl getDocumentsFile] stringByAppendingPathComponent:column_show_file_name];
    _showNameArray = [[NSMutableArray alloc]initWithContentsOfFile:pathName];
    NSString *Name = [[FileUrl getDocumentsFile] stringByAppendingPathComponent:column_disshow_file_name];
    _addNameArray = [[NSMutableArray alloc]initWithContentsOfFile:Name];
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
    NSString *pathName = [[FileUrl getDocumentsFile] stringByAppendingPathComponent:column_show_file_name];
    [_showNameArray writeToFile:pathName atomically:YES];
    NSString *Name = [[FileUrl getDocumentsFile] stringByAppendingPathComponent:column_disshow_file_name];
    [_addNameArray writeToFile:Name atomically:YES];
    
    [self.eventDelegate columnChanged:_showNameArray];
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
        // Delete the row from the data source
        NSDictionary *dic = [[_showNameArray objectAtIndex:indexPath.row] retain];
        [_showNameArray removeObject:dic];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_addNameArray addObject:dic];
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:_addNameArray.count-1 inSection:1];
        [tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        NSDictionary *dic = [[_addNameArray objectAtIndex:indexPath.row] retain];
        [_addNameArray removeObject:dic];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_showNameArray addObject:dic];
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:_showNameArray.count-1 inSection:0];
        [tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    }   
}



// Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
     if (toIndexPath.section ==0 &&toIndexPath.row ==0) {
         [self.tableView reloadData];

         return;
     }
     NSMutableArray *array = fromIndexPath.section ==0? _showNameArray:_addNameArray;
     NSDictionary *column = [[array objectAtIndex:fromIndexPath.row] retain];
     [array removeObject:column];
     
     array = toIndexPath.section ==0 ?_showNameArray :_addNameArray;
     [array insertObject:column atIndex:toIndexPath.row];
     
//     for (id text in _fontsArray) {
//         NSLog(@"font : %@", text);
//     }
//     NSLog(@"___________");
//     
//     NSString *text = [[_fontsArray objectAtIndex:fromIndexPath.row] retain]; // 2
//     [ removeObject:text]; // 0
//     [_fontsArray insertObject:text atIndex:toIndexPath.row];
//     [text release];
//     
//     for (id text in _fontsArray) {
//         NSLog(@"change font : %@", text);
//     }
     [self.tableView reloadData];
 } // 移动结束调用


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
