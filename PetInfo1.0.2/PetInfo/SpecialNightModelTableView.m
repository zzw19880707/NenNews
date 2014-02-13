//
//  SpecialNightModelTableView.m
//  东北新闻网
//
//  Created by tenyea on 14-1-26.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "SpecialNightModelTableView.h"
#import "ThemeManager.h"
#import "NightAndLoadingCell.h"
#import "Uifactory.h"
#import "UIImageView+WebCache.h"
#import "ColumnModel.h"
#import "SpecialVedioImageCell.h"
#define column_heigh 205.0f
#define Label_font 13
@implementation SpecialNightModelTableView

-(id)init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NightModeChangeNotification:) name:kNightModeChangeNofication object:nil];
        self.isMore = NO;
        self.HidenMore = YES;
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
    return 1+self.data.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        if (_ImgData.count>0&&_abstract.length>0) {
            return 2;
        }
        return 1;
    }else{
        NSDictionary  *dic = self.data[section-1];
        NSArray *array = [dic objectForKey:@"subject_news"];
        if ([[dic objectForKey:@"subject_type"] intValue] == 0) {
            return array.count;
        }
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    
//    导图或者导语
        if (indexPath.section == 0) {
            static NSString *listIndentifier=@"listIndentifier";
            UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:listIndentifier];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listIndentifier];
                UIImageView *image = [[[UIImageView alloc]init]autorelease];
                image.tag = 10000;
                image.frame = CGRectMake(0, 0, cell.contentView.width, cell.contentView.height);
                [cell.contentView addSubview:image];
                UILabel *label = [Uifactory createLabel:kselectText];
                label.tag = 10001;
                label.font = [UIFont systemFontOfSize:Label_font];
                label.frame = CGRectMake(0, 0, cell.contentView.width, cell.contentView.height);
                [cell.contentView addSubview:label];
            }
            if (indexPath.row == 0 &&![[_ImgData objectForKey:@"newsimg"] isEqualToString:@""]) {
                UIImageView *imageView = (UIImageView *)VIEWWITHTAG(cell.contentView, 10000);
                NSString *size = [_ImgData objectForKey:@"newsimgsize"];
                imageView.frame = CGRectMake(0, 0, 320, [[size componentsSeparatedByString:@"x"][1] floatValue]);
                [imageView setHidden:NO];
                [imageView setImageWithURL:[NSURL URLWithString:[_ImgData objectForKey:@"newsimg"]] placeholderImage:LogoImage];
                UILabel *label = (UILabel *)VIEWWITHTAG(cell.contentView, 10001);
                [label setHidden:YES];
            }else{
                UIImageView *imageView = (UIImageView *)VIEWWITHTAG(cell.contentView, 10000);
                [imageView setHidden:YES];
                UILabel *label = (UILabel *)VIEWWITHTAG(cell.contentView, 10001);
                [label setHidden:NO];
                label.text = _abstract;
                [label sizeToFit];
            }
            if (WXHLOSVersion()>=7.0) {
                cell.backgroundColor = [[ThemeManager shareInstance ]getBackgroundColor];
            }else{
                cell.contentView.backgroundColor = [[ThemeManager shareInstance ]getBackgroundColor];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
            NSDictionary *modeldic =self.data[indexPath.section-1] ;
            int type = [[modeldic objectForKey:@"subject_type" ] intValue];
            if (type ==0 ) {
                static NSString *contentIndentifier = @"HomeDetailCell";
                NightAndLoadingCell *cell=[tableView  dequeueReusableCellWithIdentifier:contentIndentifier];
                if ( cell == nil) {
                    cell = [[NightAndLoadingCell alloc]initWithshoWImage:1 type:1 ];
                    
                }
                NSDictionary *dic = [modeldic objectForKey:@"subject_news"][indexPath.row];
                ColumnModel *model = [[ColumnModel alloc]initWithDataDic:dic];
                cell.model =model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;

            }else {
                SpecialVedioImageCell *cell = [[SpecialVedioImageCell alloc] initWithData:[self.data[indexPath.section -1]objectForKey:@"subject_news"] andType:type];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
       }


    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0 ) {
            if (_ImgData.count >0) {
                NSString *size = [_ImgData objectForKey:@"newsimgsize"];
                return [[size componentsSeparatedByString:@"x"][1] floatValue];
            }else{
                CGSize size = [_abstract sizeWithFont:[UIFont systemFontOfSize:Label_font] constrainedToSize:CGSizeMake(ScreenWidth, 1000)];
                return size.height+10;
            }
        }else{
            CGSize size = [_abstract sizeWithFont:[UIFont systemFontOfSize:Label_font] constrainedToSize:CGSizeMake(ScreenWidth, 1000)];
            return size.height+10;
        }
    }else{
        NSDictionary *dic  = self.data[indexPath.section -1];
        int type = [[dic objectForKey:@"subject_type"] intValue];
        if (type ==0) {//综合新闻
            ColumnModel *model = [[ColumnModel alloc]initWithDataDic:[dic objectForKey:@"subject_news"][indexPath.row] ];
            if (model.img1.length>2&&model.img2.length>2&&model.img3.length>2) {
                return 110;
            }
            return 80;
        }else{
            NSArray *array = [dic objectForKey:@"subject_news"];
            if (array.count%2 ==0) {
                return array.count/2 *column_heigh;
            }else{
                return array.count/2 *column_heigh + column_heigh ;
            }
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0 ) {
        return @"";
    }else{
        return [self.data[section -1 ] objectForKey:@"subject_part_name"];
    }
}

@end
