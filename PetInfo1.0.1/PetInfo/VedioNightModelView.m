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
@implementation VedioNightModelView
@synthesize data = _data;
-(id)init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
        self.isMore = YES;
        
    }
    return self;
}
-(id)initwithData:(NSArray *)data{
    self = [self init];
    if (self) {
        self.data = data;
        [self setBackgroundColor];
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
        return _data.count/3;
    }else{
        return _data.count/3+1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return  nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

@end
