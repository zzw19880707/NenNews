//
//  WeatherViewController.h
//  东北新闻网
//
//  Created by tenyea on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "BaseViewController.h"
@interface WeatherViewController : BaseViewController <ASIRequest>
{
    NSDictionary *_dataDic;
}
@property (retain, nonatomic) IBOutlet UIImageView *backgroundView;
@property (retain, nonatomic) IBOutlet UILabel *city;

//今日天气
@property (retain, nonatomic) IBOutlet UILabel *today;
@property (retain, nonatomic) IBOutlet UILabel *todayLowtTmperature;
@property (retain, nonatomic) IBOutlet UILabel *todayHighTemperature;
@property (retain, nonatomic) IBOutlet UILabel *todayWeather;
@property (retain, nonatomic) IBOutlet UILabel *todayWind;
@property (retain, nonatomic) IBOutlet UIImageView *todayImageFirst;
@property (retain, nonatomic) IBOutlet UIImageView *todayImageSecond;
@property (retain, nonatomic) IBOutlet UIView *todayView;


//第二天
@property (retain, nonatomic) IBOutlet UILabel *secondDay;
@property (retain, nonatomic) IBOutlet UIImageView *secondImageview;
@property (retain, nonatomic) IBOutlet UILabel *secondTemperature;
@property (retain, nonatomic) IBOutlet UILabel *secondWeather;
@property (retain, nonatomic) IBOutlet UILabel *secondWind;
@property (retain, nonatomic) IBOutlet UIImageView *secondImageSecond;
@property (retain, nonatomic) IBOutlet UIView *secondView;



//第三天
@property (retain, nonatomic) IBOutlet UILabel *thirdDay;
@property (retain, nonatomic) IBOutlet UIImageView *thirdImageview;
@property (retain, nonatomic) IBOutlet UILabel *thirdTemperature;
@property (retain, nonatomic) IBOutlet UILabel *thirdWeather;
@property (retain, nonatomic) IBOutlet UILabel *thirdWind;
@property (retain, nonatomic) IBOutlet UIImageView *thirdImageSecond;

@property (retain, nonatomic) IBOutlet UIView *thirdView;

//第四天

@property (retain, nonatomic) IBOutlet UILabel *fourthDay;
@property (retain, nonatomic) IBOutlet UIImageView *fourthImageview;
@property (retain, nonatomic) IBOutlet UILabel *fourthTemperature;
@property (retain, nonatomic) IBOutlet UILabel *fourthWeather;
@property (retain, nonatomic) IBOutlet UILabel *fourthWind;
@property (retain, nonatomic) IBOutlet UIImageView *fourthImageSecond;
@property (retain, nonatomic) IBOutlet UIView *fourthView;

- (IBAction)refeshAction:(UIButton *)sender;

@end
