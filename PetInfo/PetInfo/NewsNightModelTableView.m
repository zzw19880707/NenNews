//
//  NewsNightModelTableView.m
//  东北新闻网
//
//  Created by tenyea on 13-12-29.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "NewsNightModelTableView.h"
#import "ThemeManager.h"

@implementation NewsNightModelTableView

-(id)init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
        self.isMore = YES;
        self.refreshHeader = YES;
    }
    return self;
}

-(id)initwithColumnID:(int)columnID{
    self = [self init];
    if (self) {
        self.columnID = columnID;
    }
    return self;
}
-(void)setBackgroundColor{
    self.backgroundColor = [[ThemeManager shareInstance]getBackgroundColor];
}

#pragma mark - NSNotification actions
- (void)NightModeChangeNotification:(NSNotification *)notification {
    //标题颜色，选中后标题颜色变为选中颜色，未选中为标题颜色
    [self setBackgroundColor];
}


#pragma mark ----datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
//    if (self.lastDate) {
//        
//    }
//    NSDate *_compareDate=[self.formatter dateFromString:_compareString];
//    NSTimeInterval time=[date timeIntervalSinceDate:_compareDate];
//    days=((int)time)/(3600*24);
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *listIndentifier=@"HomeDetailCell";
    UITableViewCell *cell=[tableView  dequeueReusableCellWithIdentifier:listIndentifier];
    
    if (cell==nil) {//nib文件名
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listIndentifier];
    }
    cell.textLabel.text = @"123";
    _po(@"1111111111111");
    return  cell;
    
}



@end
