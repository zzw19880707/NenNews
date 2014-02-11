//
//  VedioNightModelView.m
//  东北新闻网
//
//  Created by tenyea on 14-2-8.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "VedioNightModelView.h"
#import "VedioAndImageModel.h"
#import "ThemeManager.h"
#import "VedioNightCell.h"
@implementation VedioNightModelView
//@synthesize data = _data;
-(id)init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
        self.isMore = YES;
        self.refreshHeader = YES;
        [self setBackgroundColor];

    }
    return self;
}
-(id)initwithData:(NSArray *)data{
    self = [self init];
    if (self) {
        self.data = data;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.data.count%3 ==0) {
        return self.data.count/3;
    }else{
        return self.data.count/3+1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vedioandImageCellIdentifier = @"vedioandImageCell";
    VedioNightCell *cell = [tableView dequeueReusableCellWithIdentifier:vedioandImageCellIdentifier];
    if (cell == nil) {
        NSArray *array = nil ;
//        = @[self.data[indexPath.row*3],self.data[indexPath.row*3+1],self.data[indexPath.row*3+2]];
        switch (self.data.count -indexPath.row*3) {
            case 0:
                array = @[self.data[indexPath.row*3],self.data[indexPath.row*3+1],self.data[indexPath.row*3+2]];
                break;
            case 1:
                array = @[self.data[indexPath.row*3]];
                break;
            case 2:
                array = @[self.data[indexPath.row*3],self.data[indexPath.row*3+1]];
                break;
            default:
                array = @[self.data[indexPath.row*3],self.data[indexPath.row*3+1],self.data[indexPath.row*3+2]];

                break;
        }
        cell = [[VedioNightCell alloc]initwithType:_type andData:array andIndex:indexPath.row];
        cell.eventDelegate =  self;
    }
    
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int index = indexPath.row*3;
    VedioAndImageModel *model = self.data[index];
    if (model.videoTitle) {
        return 95;
    }else{
        return 70;
    }
}

#pragma mark VedioandImageDelegate
-(void)selectedAction:(int)i andIndex:(int)index{
    int count = index*3 +i;
    VedioAndImageModel *model = self.data[count];
    [self.VedioDelegate selectedAction:model];
}
@end
