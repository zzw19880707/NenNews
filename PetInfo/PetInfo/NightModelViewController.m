//
//  NightModelViewController.m
//  东北新闻网
//
//  Created by tenyea on 14-1-3.
//  Copyright (c) 2014年 佐筱猪. All rights reserved.
//

#import "NightModelViewController.h"
#import "FileUrl.h"
#import <ShareSDK/ShareSDK.h>
#import "FileUrl.h"
#import "FMDatabaseAdditions.h"
#import "ColumnModel.h"
@interface NightModelViewController (){
}
@end

@implementation NightModelViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)init{
    self=[super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(share:) name:kImageShareNotification object:nil];
    }
    return self;
}
#pragma mark UI
-(void)_initButton {
    //分享按钮
    UIButton *shareButton = [[UIButton alloc]init];
    shareButton.backgroundColor = CLEARCOLOR;
    [shareButton setImage:[UIImage imageNamed:@"content_share.png"] forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(0, 0, 40, 40);
    shareButton.showsTouchWhenHighlighted = YES;
    [shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
//    收藏
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor = CLEARCOLOR;
    [button setImage:[UIImage imageNamed:@"content_collection.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"content_collection_selected.png"] forState:UIControlStateSelected];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.showsTouchWhenHighlighted = YES;
    [button addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    NSArray *buttonArray = @[[shareItem autorelease],[backItem autorelease]];
    self.navigationItem.rightBarButtonItems = buttonArray;

    NSString *key = self.newsId;
    NSString *rs =[self.db stringForQuery:@"select newsId from collectionList where newsId = ? ",key];
    if (rs.length>0) {
        button.selected =YES;
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [self _initButton];

    [super viewWillAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
}
#pragma mark Action
-(void)share:(NSNotification *)notification {
    ColumnModel *model =(ColumnModel *)notification.object;
    if ([self.newsId isEqualToString:model.newsId]) {
        return;
    }
    self.newsAbstract = model.newsAbstract;
    self.titleLabel= model.title;
    self.ImageUrl = model.img;
    [self shareSDKImage];
}
-(void)shareSDKImage{
    //    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"" ofType:@""];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:_newsAbstract
                                       defaultContent:@"东北新闻网"
                                                image:[ShareSDK imageWithUrl:_ImageUrl]
                                                title:_titleLabel
                                                  url:_url
                                          description:_titleLabel
                                            mediaType:SSPublishContentMediaTypeNews];
    
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];

    
    //结束定制信息
    ////////////////////////
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:self.appDelegate];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    
    
    
    
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:

                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),

                          nil];
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                           qqButtonHidden:NO
                                                    wxSessionButtonHidden:NO
                                                   wxTimelineButtonHidden:NO
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:nil
                                                      friendsViewDelegate:nil
                                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"发表成功");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"发布失败!error code == %d, error code == %@", [error errorCode], [error errorDescription]);
                                }
                            }];

}

-(void)shareSDK{
    //    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"" ofType:@""];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:_newsAbstract
                                       defaultContent:@"东北新闻网"
                                                image:[ShareSDK imageWithUrl:_ImageUrl]
                                                title:_titleLabel
                                                  url:_url
                                          description:_titleLabel
                                            mediaType:SSPublishContentMediaTypeNews];
    
    ///////////////////////
    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
    
    //    //定制人人网信息
    [publishContent addRenRenUnitWithName:INHERIT_VALUE
                              description:INHERIT_VALUE
                                      url:INHERIT_VALUE
                                  message:INHERIT_VALUE
                                    image:INHERIT_VALUE
                                  caption:nil];
    //    //定制QQ空间信息
    [publishContent addQQSpaceUnitWithTitle:_titleLabel
                                        url:INHERIT_VALUE
                                       site:nil
                                    fromUrl:nil
                                    comment:INHERIT_VALUE
                                    summary:INHERIT_VALUE
                                      image:INHERIT_VALUE
                                       type:[NSNumber numberWithInt:4]
                                    playUrl:nil
                                       nswb:nil];
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    //    //定制微信朋友圈信息
    [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeText] content:INHERIT_VALUE title:INHERIT_VALUE url:INHERIT_VALUE thumbImage:INHERIT_VALUE image:INHERIT_VALUE musicFileUrl:nil extInfo:nil fileData:nil emoticonData:nil];
    //    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeMusic]
    //                                          content:INHERIT_VALUE
    //                                            title:_titleLabel
    //                                              url:_url
    //                                            image:INHERIT_VALUE
    //                                     musicFileUrl:nil
    //                                          extInfo:nil
    //                                         fileData:nil
    //                                     emoticonData:nil];
    //
    //    //定制QQ分享信息
    //    [publishContent addQQUnitWithType:INHERIT_VALUE
    //                              content:INHERIT_VALUE
    //                                title:@"Hello QQ!"
    //                                  url:INHERIT_VALUE
    //                                image:INHERIT_VALUE];
    //
    
    //    新浪和qq微博
    [publishContent addTencentWeiboUnitWithContent:[NSString stringWithFormat:@"%@ %@",_titleLabel,_url] image:INHERIT_VALUE locationCoordinate:nil];
    [publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"%@ %@",_titleLabel,_url] image:INHERIT_VALUE locationCoordinate:nil];
    
    //结束定制信息
    ////////////////////////
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:self.appDelegate];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    //自定义新浪微博分享菜单项
    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                                                              icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                                                      clickHandler:^{
                                                                          [ShareSDK shareContent:publishContent
                                                                                            type:ShareTypeSinaWeibo
                                                                                     authOptions:authOptions
                                                                                   statusBarTips:YES
                                                                                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                              
                                                                                              if (state == SSPublishContentStateSuccess)
                                                                                              {
                                                                                                  NSLog(@"分享成功");
                                                                                              }
                                                                                              else if (state == SSPublishContentStateFail)
                                                                                              {
                                                                                                  NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                              }
                                                                                          }];
                                                                      }];
    //自定义腾讯微博分享菜单项
    id<ISSShareActionSheetItem> tencentItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeTencentWeibo]
                                                                                 icon:[ShareSDK getClientIconWithType:ShareTypeTencentWeibo]
                                                                         clickHandler:^{
                                                                             [ShareSDK shareContent:publishContent
                                                                                               type:ShareTypeTencentWeibo
                                                                                        authOptions:authOptions
                                                                                      statusBarTips:YES
                                                                                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                                 
                                                                                                 if (state == SSPublishContentStateSuccess)
                                                                                                 {
                                                                                                     NSLog(@"分享成功");
                                                                                                 }
                                                                                                 else if (state == SSPublishContentStateFail)
                                                                                                 {
                                                                                                     NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                                 }
                                                                                             }];
                                                                         }];
    //自定义QQ空间分享菜单项
    id<ISSShareActionSheetItem> qzoneItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeQQSpace]
                                                                               icon:[ShareSDK getClientIconWithType:ShareTypeQQSpace]
                                                                       clickHandler:^{
                                                                           [ShareSDK shareContent:publishContent
                                                                                             type:ShareTypeQQSpace
                                                                                      authOptions:authOptions
                                                                                    statusBarTips:YES
                                                                                           result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                               
                                                                                               if (state == SSPublishContentStateSuccess)
                                                                                               {
                                                                                                   NSLog(@"分享成功");
                                                                                               }
                                                                                               else if (state == SSPublishContentStateFail)
                                                                                               {
                                                                                                   NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                               }
                                                                                           }];
                                                                       }];
    
    
    
    //自定义人人网分享菜单项
    id<ISSShareActionSheetItem> rrItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeRenren]
                                                                            icon:[ShareSDK getClientIconWithType:ShareTypeRenren]
                                                                    clickHandler:^{
                                                                        [ShareSDK shareContent:publishContent
                                                                                          type:ShareTypeRenren
                                                                                   authOptions:authOptions
                                                                                 statusBarTips:YES
                                                                                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                            
                                                                                            if (state == SSPublishContentStateSuccess)
                                                                                            {
                                                                                                NSLog(@"分享成功");
                                                                                            }
                                                                                            else if (state == SSPublishContentStateFail)
                                                                                            {
                                                                                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                            }
                                                                                        }];
                                                                    }];
    
    
    
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                          sinaItem,
                          tencentItem,
                          //                          SHARE_TYPE_NUMBER(ShareTypeSMS),
                          qzoneItem,
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeQQ),
                          rrItem,
                          SHARE_TYPE_NUMBER(ShareTypeCopy),
                          nil];
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                           qqButtonHidden:NO
                                                    wxSessionButtonHidden:NO
                                                   wxTimelineButtonHidden:NO
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:nil
                                                      friendsViewDelegate:nil
                                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"发表成功");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"发布失败!error code == %d, error code == %@", [error errorCode], [error errorDescription]);
                                }
                            }];

}
//分享
-(void)shareAction:(UIButton *)button{
    [self shareSDK];
}
//收藏
-(void)collectAction:(UIButton *)button{
    
    NSString *key =self.newsId;
    if (button.selected) {
        BOOL success =[self.db executeUpdate:@"delete from collectionList where newsId = ?",key];
        if (success) {
            [self showHUD:INFO_DisCollectionSuccess isDim:YES];
            button.selected = !button.selected;
        }else{
            [self showHUD:INFO_DisCollectionError isDim:YES];
            button.selected = NO;

        }
        
    }else{
        BOOL success =[self.db executeUpdate:@"insert into collectionList values (?,?,?)",key,_titleLabel,[NSNumber numberWithInt:_type]];
        
        if (success) {
            [self showHUD:INFO_CollectionSuccess isDim:YES];
            button.selected = !button.selected;
        }else{
            [self showHUD:INFO_CollectionError isDim:YES];
            button.selected = YES;
        }
        
    }
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:.5];
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
