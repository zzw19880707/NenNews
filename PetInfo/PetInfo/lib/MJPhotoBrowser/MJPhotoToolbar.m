//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
#import "MBProgressHUD+Add.h"
#import "ColumnModel.h"
@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
    
    //    标题
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    
    UIScrollView *_bgcontentScroll;
}
@end

@implementation MJPhotoToolbar
static const CGFloat labelPadding = 10;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:14];
        _indexLabel.frame = CGRectMake(ScreenWidth-70+labelPadding, 0, 70-labelPadding*2, 15);
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    }
    
    //    标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelPadding/2, 0, ScreenWidth-70, 15)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = UITextAlignmentLeft;
    _titleLabel.numberOfLines = 1;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_titleLabel];
    
    
   
    
    //  内容
    _bgcontentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(labelPadding/2, 20, ScreenWidth-labelPadding*2, 45)];
    _bgcontentScroll.showsHorizontalScrollIndicator = NO;
    _bgcontentScroll.backgroundColor = [UIColor clearColor];
    _bgcontentScroll.showsVerticalScrollIndicator = YES;
    [self addSubview:_bgcontentScroll];
    //    内容
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-labelPadding*2, 15)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textAlignment = UITextAlignmentLeft;
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    [_bgcontentScroll addSubview:_contentLabel];
    

    // 保存图片按钮
    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveImageBtn.frame =  CGRectMake(ScreenWidth - 35-40, 70, 35, 35);
    //    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_saveImageBtn setImage:[UIImage imageNamed:@"photo_down.png"] forState:UIControlStateNormal];
    [_saveImageBtn setImage:[UIImage imageNamed:@"photo_down.png"] forState:UIControlStateHighlighted];
    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveImageBtn];

    
    //    分享 |下载图片
    UIButton *shareButton = [[UIButton alloc] init];
    shareButton.frame = CGRectMake( ScreenWidth - 70-80, 70 , 35, 35);
    [shareButton setImage:[UIImage imageNamed:@"content_share.png"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"content_share.png"] forState:UIControlStateHighlighted];
    [shareButton addTarget: self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButton];
    
    self.backgroundColor = [UIColor grayColor];
    self.alpha = .7;
   //    // 保存图片按钮
//    CGFloat btnWidth = self.bounds.size.height;
//    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _saveImageBtn.frame = CGRectMake(20, 0, btnWidth, btnWidth);
//    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
//    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
//    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_saveImageBtn];
}
-(void)shareAction{
    ColumnModel *model = [[ColumnModel alloc]init];
    model.type = [NSNumber numberWithInt:2];
    model.title = _titleLabel.text;
    model.newsAbstract = _contentLabel.text;
    model.isselected = 1;
    model.newsId = @"123";
    MJPhoto *photo =_photos[_currentPhotoIndex];
    model.img = [photo.url absoluteString];
    [[NSNotificationCenter defaultCenter]postNotificationName:kImageShareNotification object:model];
}
- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.enabled = NO;
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%d / %d", _currentPhotoIndex + 1, _photos.count];
    
    MJPhoto *photo = _photos[_currentPhotoIndex];
    if (photo.firstShow) {
        _saveImageBtn.enabled = YES;
    }else{
        // 按钮
        _saveImageBtn.enabled = photo.image != nil && !photo.save;

    }
    
    
    _titleLabel.text = photo.title;
    _contentLabel.text = photo.content;
    CGSize size = [_contentLabel sizeThatFits:CGSizeMake(ScreenWidth-labelPadding*2, 1000)];
    _contentLabel.height = size.height;
    float heigh =  size.height;
    _bgcontentScroll.contentSize = CGSizeMake(ScreenWidth - 70, heigh);
}

@end
