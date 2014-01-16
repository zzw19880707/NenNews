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
    NSString *locationcityid = [[NSUserDefaults standardUserDefaults]objectForKey:kLocationCityCode];
    
    NSString *path = [[FileUrl getDocumentsFile]stringByAppendingPathComponent:kWeatherData_file_name];
    _dataDic = [[NSDictionary alloc]initWithContentsOfFile:path];
    if (_dataDic==nil||_dataDic.count ==0) {
    }else{
        [self _loadWeatherData];
        NSString *lastDate = [_dataDic objectForKey:@"date_y"];
        NSString *cityid = [_dataDic objectForKey:@"cityid"];
        //    NSDateformat
        NSDateFormatter *dataformatter = [[NSDateFormatter alloc]init];
        [dataformatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *currentDateStr = [dataformatter stringFromDate:[NSDate date]];
        if ([lastDate isEqualToString:currentDateStr]) {
            if ([cityid isEqualToString:locationcityid]) {
                return;
            }
        }
    }
    if ([self getConnectionAlert]) {
        DataService *service = [[DataService alloc]init];
        service.eventDelegate = self;
        NSString *url = [Weather_URL stringByAppendingString:[NSString stringWithFormat:@"%@%@",locationcityid,@".html"]];
        [service requestWithURL:url andparams:nil isJoint:NO andhttpMethod:@"GET"];
    }
}

//填充数据
//
-(void)_loadWeatherData{
    NSArray *weekArray = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    NSString *todayweek = [_dataDic objectForKey:@"week"];;
    self.today.text =todayweek;
    int index = 0;
    for (int i = 0 ; i<weekArray.count; i++) {
        if ([todayweek isEqualToString:weekArray[i]]) {
            index = i;
            break;
        }
    }
    self.city.text = [_dataDic objectForKey:@"city"];
    NSString *todayTemp = [_dataDic objectForKey:@"temp1"];
    NSArray *tempArray = [todayTemp componentsSeparatedByString:@"~"];
    self.todayLowtTmperature.text = tempArray[0];
    self.todayHighTemperature.text = tempArray[1];
    NSString *weather = [_dataDic objectForKey:@"weather1"];
    self.todayWeather.text = weather;
    UIImageView *background = [[UIImageView alloc]init];
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
    self.todayWind.text = [_dataDic objectForKey:@"fl1"];
    self.todayImageFirst.image =[UIImage imageNamed:[NSString stringWithFormat:@"b%@.png",[_dataDic objectForKey:@"img1"]]];
    
    if ([[_dataDic objectForKey:@"img2"] isEqualToString:@"99"]) {
        self.todayImageSecond.image =[UIImage imageNamed:[NSString stringWithFormat:@"b%@.png",[_dataDic objectForKey:@"img1"]]];
    }else{
        self.todayImageSecond.image =[UIImage imageNamed:[NSString stringWithFormat:@"b%@.png",[_dataDic objectForKey:@"img2"]]];

    }
    //第二天
    if (index==7) {
        index =0;
    }
    self.secondDay.text = weekArray[index++];
    self.secondTemperature.text = [_dataDic objectForKey:@"temp2"];
    self.secondWeather.text = [_dataDic objectForKey:@"weather2"];
    self.secondWind.text = [_dataDic objectForKey:@"fl2"];
    self.secondImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"b%@.png",[_dataDic objectForKey:@"img3"]]];
    if ([[_dataDic objectForKey:@"img4"] isEqualToString:@"99"]) {
        self.secondImageSecond.image = [UIImage imageNamed:[NSString stringWithFormat:@"b%@.png",[_dataDic objectForKey:@"img3"]]];
    }else{
        self.secondImageSecond.image =[UIImage imageNamed:[NSString stringWithFormat:@"b%@.png",[_dataDic objectForKey:@"img4"]]];
        
    }
    //第三天
    if (index==7) {
        index =0;
    }
    self.thirdDay.text = weekArray[index++];
    self.thirdTemperature.text = [_dataDic objectForKey:@"temp3"];
    self.thirdWeather.text = [_dataDic objectForKey:@"weather3"];
    self.thirdWind.text = [_dataDic objectForKey:@"fl3"];
    self.thirdImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"b%@.png",[_dataDic objectForKey:@"img5"]]];
    if ([[_dataDic objectForKey:@"img6"] isEqualToString:@"99"]) {
        self.thirdImageSecond.image = [UIImage imageNamed:[NSString stringWithFormat:@"b%@.png",[_dataDic objectForKey:@"img5"]]];
    }else{
        self.thirdImageSecond.image =[UIImage imageNamed:[NSString stringWithFormat:@"b%@.png",[_dataDic objectForKey:@"img6"]]];
    }
    //第四天
    if (index==7) {
        index =0;
    }
    self.fourthDay.text = weekArray[index++];
    self.fourthTemperature.text = [_dataDic objectForKey:@"temp4"];
    self.fourthWeather.text = [_dataDic objectForKey:@"weather4"];
    self.fourthWind.text = [_dataDic objectForKey:@"fl4"];
    self.fourthImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"b%@.png",[_dataDic objectForKey:@"img7"]]];
    if ([[_dataDic objectForKey:@"img8"] isEqualToString:@"99"]) {
        self.fourthImageSecond.image = [UIImage imageNamed:[NSString stringWithFormat:@"b%@.png",[_dataDic objectForKey:@"img7"]]];
    }else{
        self.fourthImageSecond.image =[UIImage imageNamed:[NSString stringWithFormat:@"b%@.png",[_dataDic objectForKey:@"img8"]]];
    }
    
}
#pragma mark ASIRequest
-(void)requestFailed:(ASIHTTPRequest *)request{

}
-(void)requestFinished:(id)result{
    NSDictionary *dic = [result objectForKey:@"weatherinfo"];
    _dataDic = dic;
    NSString *path = [[FileUrl getDocumentsFile]stringByAppendingPathComponent:kWeatherData_file_name];

    [_dataDic writeToFile:path atomically:YES];
    [self _loadWeatherData];
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
