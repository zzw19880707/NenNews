//
//  CityCodeViewController.h
//  东北新闻网
//
//  Created by tenyea on 13-12-26.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityCodeViewController : UITableViewController{
    NSArray *_cityData;
    NSDictionary *_dataDic;
    NSArray      *_keyArray;

}
@property (nonatomic,retain) NSArray *cityData;
@end
