//
//  CityCodeViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-26.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "CityCodeViewController.h"
#import "FileUrl.h"
@interface CityCodeViewController ()

@end

@implementation CityCodeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.sectionIndexColor = [UIColor grayColor];
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    NSString *str = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"plist"];
    self.cityData = [NSArray arrayWithContentsOfFile:str];
    //索引
    NSString *index = [[NSBundle mainBundle]pathForResource:@"cityindex" ofType:@"plist"];
    _dataDic = [[NSDictionary dictionaryWithContentsOfFile:index]retain];
    
    NSMutableArray *keyarray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i<_cityData.count;  i++ ) {
        NSString *city = [_cityData[i] objectForKey:@"省"];
        [keyarray addObject:city];
    }
    _keyArray = [[NSArray arrayWithArray:keyarray]retain];
    [keyarray release];
    
//    NSMutableDictionary *citycode = [[NSMutableDictionary alloc]init];
//    for (int i = 0 ; i<_cityData.count; i++) {
//        NSArray *array =[_cityData[i] objectForKey:@"市"];
//        NSMutableArray *array1 = [[NSMutableArray alloc]init];
//        for (int j = 0 ; j<array .count; j++) {
////            [citycode setValue:[array[j] objectForKey:@"编码"] forKey:[array[j] objectForKey:@"市名"]];
//            [array1  addObject:[array[j] objectForKey:@"市名"]];
//        }
//        NSString *city = [_cityData[i] objectForKey:@"省"];
//        [citycode setValue:array1 forKey:city];
//        [array1 release];
//    }
//    [citycode writeToFile:[[FileUrl getDocumentsFile] stringByAppendingPathComponent:@"cityindex.plist"] atomically:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return _cityData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSDictionary *dic = _cityData[section];
    NSArray *array =[dic objectForKey:@"市"];
    return [array count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSDictionary *dic = _cityData[section];
//    return [dic objectForKey:@"省"];
    return _keyArray[section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDictionary *dic = _cityData[indexPath.section];
    NSArray *array =[dic objectForKey:@"市"];

    cell.textLabel.text = [array[indexPath.row] objectForKey:@"市名"];
    NSString *code = [array[indexPath.row] objectForKey:@"编码"];
    cell.tag = [code intValue];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSLog(@"index : %d title : %@", index, title);
    return index;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keyArray;
} // 返回索引的内容
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _cityData[indexPath.section];
    NSArray *array =[dic objectForKey:@"市"];
    
    NSString *code = [array[indexPath.row] objectForKey:@"编码"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:code forKey:kLocationCityCode];
    [user synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
 

@end
