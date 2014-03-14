//
//  BaseNightModelCell.m
//  东北新闻网
//
//  Created by tenyea on 14-1-26.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "BaseNightModelCell.h"
#import "ThemeManager.h"
@implementation BaseNightModelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
        [self setcolor];

    }
    return self;
}


#pragma mark - NSNotification actions
//夜间模式
-(void)NightModeChangeNotification:(NSNotification *)nsnotification{
    [self setcolor];
}
-(void)setcolor{
    self.backgroundColor = [[ThemeManager shareInstance]getBackgroundColor];
    self.textLabel.textColor = [[ThemeManager shareInstance]getColorWithName:ktext];
}
@end
