//
//  WeatherViewController.m
//  东北新闻网
//
//  Created by tenyea on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "WeatherViewController.h"
#import "CityCodeViewController.h"
#import "FileUrl.h"
#import "NSString+URLEncoding.h"
@interface WeatherViewController (){
    NSTimer *_timer;
}

@end

@implementation WeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"天气";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [self loadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button =[[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setImage:[UIImage imageNamed:@"weather_location_button.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itme = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem =itme;
    [itme release];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeweatherView) userInfo:nil repeats:YES] ;
}

#pragma mark Action
-(void)changeweatherView{
    //block动画语法
    [UIView transitionWithView:self.todayView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [self.todayView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    } completion:NULL];
    [UIView transitionWithView:self.secondView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [self.secondView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    } completion:NULL];
    [UIView transitionWithView:self.thirdView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [self.thirdView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    } completion:NULL];
    [UIView transitionWithView:self.fourthView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [self.fourthView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    } completion:NULL];
}

- (IBAction)refeshAction:(UIButton *)sender {
    [self loadData];
}
-(void)selectCity{
    [self.navigationController pushViewController:[[[CityCodeViewController alloc]init]autorelease] animated:YES];
}

-(void)loadData{
    NSString *locationcityName = [[NSUserDefaults standardUserDefaults]objectForKey:kLocationCityName];

    NSString *path = [[FileUrl getDocumentsFile]stringByAppendingPathComponent:kWeatherData_file_name];
    _dataDic = [[NSArray alloc]initWithContentsOfFile:path];
    if (_dataDic==nil||_dataDic.count ==0) {
        NSArray *views = [self.view subviews];
        for (UIView *view in views) {
            [view setHidden:YES];
        }
    }else{
        NSArray *views = [self.view subviews];
        for (UIView *view in views) {
            [view setHidden:NO];
        }
        [self _loadWeatherData];
    }
    if ([self getConnectionAlert]) {
        DataService *service = [[DataService alloc]init];
        service.eventDelegate = self;
        NSString *url = [Weather_URL stringByAppendingString:[NSString stringWithFormat:@"%@%@",locationcityName.URLEncodedString,Weather_Parms]];
        [service requestWithURL:url andparams:nil isJoint:NO andhttpMethod:@"GET"];
    }
}

//填充数据
//
-(void)_loadWeatherData{
//    第一天
    NSDictionary *todayDic =_dataDic[0];
    NSString *todayWeek = [todayDic objectForKey:@"date"];
    self.today.text = [todayWeek componentsSeparatedByString:@"("][0];
    NSString *todayTem = [todayDic objectForKey:@"temperature"];
    NSArray *todayTemArray  = [todayTem componentsSeparatedByString:@"~"];
    self.todayLowtTmperature.text = todayTemArray[0];
    self.todayHighTemperature.text = todayTemArray[1];
    self.todayWeather.text = [todayDic objectForKey:@"weather"];
    self.todayWind.text = [todayDic objectForKey:@"wind"];
    NSString *todayImageName = [todayDic objectForKey:@"dayPictureUrl"];
    NSString *todayImgName = [[[todayImageName componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."][0];
    self.todayImageFirst.image  = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",todayImgName]];
    

    
//    //第二天
    
    NSDictionary *secondDic = _dataDic[1];
    NSString *secondWeek = [secondDic objectForKey:@"date"];
    self.secondDay.text = secondWeek;
    NSString *secondTem = [secondDic objectForKey:@"temperature"];
    self.secondTemperature.text = secondTem;
    self.secondWeather.text = [secondDic objectForKey:@"weather"];
    self.secondWind.text = [secondDic objectForKey:@"wind"];
    NSString *secondImageName = [secondDic objectForKey:@"dayPictureUrl"];
    NSString *secondImgName = [[[secondImageName componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."][0];
    self.self.secondImageSecond.image  = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",secondImgName]];

//    //第三天
    NSDictionary *thirdDic = _dataDic[2];
    NSString *thirdWeek = [thirdDic objectForKey:@"date"];
    self.thirdDay.text = thirdWeek;
    NSString *thirdTem = [thirdDic objectForKey:@"temperature"];
    self.thirdTemperature.text = thirdTem;
    self.thirdWeather.text = [thirdDic objectForKey:@"weather"];
    self.thirdWind.text = [thirdDic objectForKey:@"wind"];
    NSString *thirdImageName = [thirdDic objectForKey:@"dayPictureUrl"];
    NSString *thirdImgName = [[[thirdImageName componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."][0];
    self.self.thirdImageSecond.image  = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",thirdImgName]];
//    //第四天
    NSDictionary *fourthDic = _dataDic[3];
    NSString *fourthWeek = [fourthDic objectForKey:@"date"];
    self.fourthDay.text = fourthWeek;
    NSString *fourthTem = [fourthDic objectForKey:@"temperature"];
    self.fourthTemperature.text = fourthTem;
    self.fourthWeather.text = [fourthDic objectForKey:@"weather"];
    self.fourthWind.text = [fourthDic objectForKey:@"wind"];
    NSString *fourthImageName = [fourthDic objectForKey:@"dayPictureUrl"];
    NSString *fourthImgName = [[[fourthImageName componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."][0];
    self.self.fourthImageSecond.image  = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",fourthImgName]];
    //  背景图片
    UIImageView *background = [[UIImageView alloc]init];
    NSString *weather = [todayDic objectForKey:@"weather"];
    if ([weather isEqualToString:@"晴"]) {
        background.image = [UIImage imageNamed:@"weather_background_sunny.png"];
    }else if ([weather isEqualToString:@"雪"]){
        background.image = [UIImage imageNamed:@"weather_background_snow.png"];
    }else if ([weather isEqualToString:@"雨"]){
        background.image = [UIImage imageNamed:@"weather_background_middlerain.png"];
    }else if ([weather isEqualToString:@"阵雨"]){
        background.image = [UIImage imageNamed:@"weather_background_rain.png"];
    }else if ([weather isEqualToString:@"阴"]){
        background.image = [UIImage imageNamed:@"weather_background_cloudy.png"];
    }else if ([weather isEqualToString:@"雷阵雨"]){
        background.image = [UIImage imageNamed:@"weather_background_thundershower.png"];
    }else if ([weather isEqualToString:@"多云"]){
        background.image = [UIImage imageNamed:@"weather_background_morecloudy.png"];
    }else{
        background.image = [UIImage imageNamed:@"weather_background.png"];
    }
    self.backgroundView.image = background.image;
    [background release];
    
    
}
#pragma mark ASIRequest
-(void)requestFailed:(ASIHTTPRequest *)request{
    [self showHUD:INFO_ERROR isDim:YES];
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:3];
}
-(void)requestFinished:(id)result{
    NSString *status = [result objectForKey:@"status"];
    if ( [status isEqualToString:@"success"]) {
        NSArray *array = [result objectForKey:@"results"] ;
        NSArray *date =  [array[0] objectForKey:@"weather_data"];
        self.city.text = [array[0] objectForKey:@"currentCity"];

        _dataDic = date;
        NSString *path = [[FileUrl getDocumentsFile]stringByAppendingPathComponent:kWeatherData_file_name];

        [_dataDic writeToFile:path atomically:YES];
        [self _loadWeatherData];
    }else{
        [self showHUD:INFO_ERROR isDim:YES];
        [self performSelector:@selector(hideHUD) withObject:nil afterDelay:3];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)dealloc {
    if ([_timer isValid]) {
        [_timer release];
    }
    [_today release];
    [_todayLowtTmperature release];
    [_todayHighTemperature release];
    [_todayWeather release];
    [_todayWind release];
    [_todayImageFirst release];
    [_todayImageSecond release];
    [_todayView release];

    
    [_secondDay release];
    [_secondImageview release];
    [_secondTemperature release];
    [_secondWeather release];
    [_secondImageSecond release];
    [_secondWind release];
    [_secondView release];
    

    [_thirdDay release];
    [_thirdImageview release];
    [_thirdTemperature release];
    [_thirdWeather release];
    [_thirdImageSecond release];
    [_thirdWind release];
    [_thirdView release];

    [_backgroundView release];
    [_city release];

    
    [_fourthDay release];
    [_fourthImageview release];
    [_fourthTemperature release];
    [_fourthWeather release];
    [_fourthImageSecond release];
    [_fourthWind release];
    [_fourthView release];
    [_dataDic release];
    [super dealloc];
}
- (void)viewDidUnload {
    _timer = nil;
    
    _today =nil;
    _todayLowtTmperature =nil;
    _todayHighTemperature =nil;
    _todayWeather =nil;
    _todayWind =nil;
    _todayImageFirst =nil;
    _todayImageSecond =nil;
    _todayView =nil;
    
    
    _secondDay =nil;
    _secondImageview =nil;
    _secondTemperature =nil;
    _secondWeather =nil;
    _secondImageSecond =nil;
    _secondWind =nil;
    _secondView =nil;
    
    _thirdDay =nil;
    _thirdImageview =nil;
    _thirdTemperature =nil;
    _thirdWeather =nil;
    _thirdImageSecond =nil;
    _thirdWind =nil;
    _thirdView =nil;
    
    _backgroundView =nil;
    _city =nil;
    
    _fourthDay =nil;
    _fourthImageview =nil;
    _fourthTemperature =nil;
    _fourthWeather =nil;
    _fourthImageSecond =nil;
    _fourthWind =nil;
    _fourthView =nil;
    _dataDic =nil;
    [super viewDidUnload];
}

@end
