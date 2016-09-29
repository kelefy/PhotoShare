//
//  SimpleEditStickerController.m
//  PhotoShare
//
//  Created by kongfanyi on 16/7/24.
//  Copyright © 2016年 dd. All rights reserved.
//

#import "SimpleEditStickerController.h"
#import "UIColor+Puertorico.h"
#import "UIColor+Viking.h"
#import "UIColor+Silversand.h"
#import "UIColor+Hex.h"
#import "UIView+Extension.h"
#import "UIImage+blurryImage.h"

@interface SimpleEditStickerController()

@property (weak,nonatomic) UIButton *left;
@property (weak,nonatomic) UIButton *right;
@property (weak,nonatomic) UIButton *blur;
@property (weak,nonatomic) UIButton *fullScreen;
@property (nonatomic,copy) UIImage *sourceImage;

@end

@implementation SimpleEditStickerController
{
    CGSize _stickSize;
    BOOL _isBlured;
    BOOL _isFullScreen;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBarHidden:YES];
}


- (void)configDefaultStyleView:(TuSDKPFEditStickerView *)view
{
    [super configDefaultStyleView:view];
    
    //返回按键
    UIButton *left = [UIButton buttonWithFrame:CGRectMake(0, 0, 70, 70) imageName:@"TuSDK.bundle/ui_default/style_default_edit_button_cancel_bg"];
    [left addTarget:self action:@selector(backActionHadAnimated) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:left];
    self.left = left;
    
    
    //确定按键
    UIButton *right = [UIButton buttonWithFrame:CGRectMake(view.width-70, 0, 70, 70) imageName:@"TuSDK.bundle/ui_default/style_default_edit_button_confirm_bg"];
    [right addTarget:self action:@selector(onImageCompleteAtion1) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:right];
    self.right = right;
    
    //虚化按键
    UIButton *blur = [UIButton buttonWithType:UIButtonTypeSystem];
    [blur setTitle:@"虚化" forState:UIControlStateNormal];
    [blur setTitle:@"取消" forState:UIControlStateSelected];
    [blur setBackgroundColor:[UIColor redColor]];
    blur.layer.masksToBounds = YES;
    blur.layer.cornerRadius = 30;
    blur.frame = CGRectMake(5, self.defaultStyleView.bottomBar.getOriginY - 65, 60, 60);
    [blur addTarget:self action:@selector(onBlurAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:blur];
    self.blur = blur;
    
    
    //全屏按键
    UIButton *fullScreen = [UIButton buttonWithType:UIButtonTypeSystem];
    [fullScreen setTitle:@"全屏" forState:UIControlStateNormal];
    [fullScreen setTitle:@"取消" forState:UIControlStateSelected];
    [fullScreen setBackgroundColor:[UIColor redColor]];
    fullScreen.layer.masksToBounds = YES;
    fullScreen.layer.cornerRadius = 30;
    fullScreen.frame = CGRectMake(self.view.width-65, self.defaultStyleView.bottomBar.getOriginY - 65, 60, 60);
    [fullScreen addTarget:self action:@selector(onFullScreenAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:fullScreen];
    self.fullScreen = fullScreen;
    
    view.cutRegionView.edgeMaskColor = [UIColor silverSand];
    view.imageView.height+=view.bottomBar.height;
    view.cutRegionView.height+=view.bottomBar.height;
    view.stickerView.height += view.bottomBar.height;
    //    设置bottomView事件
    [view.bottomBar.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [view.bottomBar.completeButton addTarget:self action:@selector(onImageCompleteAtion) forControlEvents:UIControlEventTouchUpInside];
    view.bottomBar.backgroundColor = [UIColor viking];
    view.stickerBar.backgroundColor = [UIColor puertoRico];
    view.stickerBar.y+=view.bottomBar.height;
    
    view.bottomBar.listButton.hidden = YES;
    view.bottomBar.onlineButton.frame = CGRectMake((view.bottomBar.frame.size.width-view.bottomBar.onlineButton.frame.size.width)/2, view.bottomBar.onlineButton.frame.origin.y, view.bottomBar.onlineButton.frame.size.width, view.bottomBar.onlineButton.frame.size.height);
    [view.bottomBar.onlineButton addTarget:self action:@selector(openOnlineAtion) forControlEvents:UIControlEventTouchUpInside];
    
    //初始化贴纸栏
    TuSDKPFStickerLocalPackage *package = [TuSDKPFStickerLocalPackage package];
    
    //只加载相框与贴纸
    TuSDKPFStickerCategory *stickerCate = [package categorieWithIdt:3];
    stickerCate.name = @"相框";
    
    
    [view.stickerBar loadCatategories:@[stickerCate,[package categorieWithIdt:1]]];
    view.stickerBar.tableView.delegate = self;
    [view.stickerBar selectCateButtonWithIndex:1];
    [view.stickerBar selectCateWithIndex:1];
    //自动加载第一张贴纸
    //    TuSDKPFStickerCategory *ca =  [package categorieWithIdt:3];
    TuSDKPFStickerGroup *group = stickerCate.datas[0];
    TuSDKPFSticker *stick = group.stickers[0];
    _stickSize = CGSizeMake(stick.size.width*2, stick.size.height*2);
    stick.size = _stickSize;
    [self appendSticker:stick];
    
    //    [view.stickerBar.paramsView setOriginX:-150];
    NSArray *arr = [view.stickerBar.paramsView subviews];
    NSInteger width = ((UIButton *)arr[0]).frame.size.width*2+10;
    for(NSInteger i=arr.count-1;i>=0;i--)
    {
        UIButton *btn = arr[i];
        [btn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateSelected];
        if(i>0)
        {
            if(i==2)
                [btn setOriginX: (view.frame.size.width-width)/2+((UIButton *)arr[0]).frame.size.width+10];
            else
                [btn setOriginX: (view.frame.size.width-width)/2];
            //            btn.frame = ((UIButton *)arr[i-1]).frame;
        }
        else
        {
            btn.hidden = YES;
        }
        
    }

}

//- (void)configDefaultStyleView:(TuSDKPFEditStickerView *)view
//{
//    if (!view) return;
//    // 初始化视图
//    [view initView];
//    view.cutRegionView.edgeMaskColor = [UIColor silverSand];
//    //    设置bottomView事件
//    [view.bottomBar.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
//    [view.bottomBar.completeButton addTarget:self action:@selector(onImageCompleteAtion) forControlEvents:UIControlEventTouchUpInside];
//    view.bottomBar.backgroundColor = [UIColor viking];
//    view.stickerBar.backgroundColor = [UIColor puertoRico];
//    view.bottomBar.listButton.hidden = YES;
//    view.bottomBar.onlineButton.frame = CGRectMake((view.bottomBar.frame.size.width-view.bottomBar.onlineButton.frame.size.width)/2, view.bottomBar.onlineButton.frame.origin.y, view.bottomBar.onlineButton.frame.size.width, view.bottomBar.onlineButton.frame.size.height);
//    [view.bottomBar.onlineButton addTarget:self action:@selector(openOnlineAtion) forControlEvents:UIControlEventTouchUpInside];
//    
//    //初始化贴纸栏
//    TuSDKPFStickerLocalPackage *package = [TuSDKPFStickerLocalPackage package];
//    
//    //只加载相框与贴纸
//    TuSDKPFStickerCategory *stickerCate = [package categorieWithIdt:3];
//    stickerCate.name = @"相框";
//    
//    
//    [view.stickerBar loadCatategories:@[stickerCate,[package categorieWithIdt:1]]];
//    view.stickerBar.tableView.delegate = self;
//    [view.stickerBar selectCateButtonWithIndex:1];
//    [view.stickerBar selectCateWithIndex:1];
//    //自动加载第一张贴纸
////    TuSDKPFStickerCategory *ca =  [package categorieWithIdt:3];
//    TuSDKPFStickerGroup *group = stickerCate.datas[0];
//    TuSDKPFSticker *stick = group.stickers[0];
//    _stickSize = CGSizeMake(stick.size.width*2, stick.size.height*2);
//    stick.size = _stickSize;
//    [self appendSticker:stick];
//    
////    [view.stickerBar.paramsView setOriginX:-150];
//    NSArray *arr = [view.stickerBar.paramsView subviews];
//    NSInteger width = ((UIButton *)arr[0]).frame.size.width*2+10;
//    for(NSInteger i=arr.count-1;i>=0;i--)
//    {
//        UIButton *btn = arr[i];
//        if(i>0)
//        {
//            if(i==2)
//                [btn setOriginX: (view.frame.size.width-width)/2+((UIButton *)arr[0]).frame.size.width+10];
//            else
//                [btn setOriginX: (view.frame.size.width-width)/2];
////            btn.frame = ((UIButton *)arr[i-1]).frame;
//        }
//        else
//        {
//            btn.hidden = YES;
//        }
//        
//    }
//    [view needUpdateLayout];
//    [self.view addSubview:view];
////    view.imageView.backgroundColor = [UIColor silverSand];
//}

-(void)cancelAction
{
    [self popViewControllerAnimated:NO];
}

-(void)onImageCompleteAtion1
{
    if(_isBlured||_isFullScreen)
    {
        NSArray<TuSDKPFStickerItemView *> *arr = self.stickerView.subviews;
        [arr enumerateObjectsUsingBlock:^(TuSDKPFStickerItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];

        //        [self popViewControllerAnimated:NO];
        self.left.hidden = YES;
        self.right.hidden = YES;
        self.blur.hidden = YES;
        CGRect rect = [UIImage getFrameSizeForImage:self.defaultStyleView.imageView.image inImageView:self.defaultStyleView.imageView];
        UIImage *image = [self ScreenShotWithRect:rect];
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        // 发送通知. 其中的Name填写第一界面的Name， 系统知道是第一界面来相应通知， object就是要传的值。 UserInfo是一个字典， 如果要用的话，提前定义一个字典， 可以通过这个来实现多个参数的传值使用。
        
        [center postNotificationName:@"stickComplete123" object:image userInfo:nil];
        [self popViewControllerAnimated:NO];
       
    }
    else
    {
        [super onImageCompleteAtion];
    }
}

-(void)openOnlineAtion
{
    [super openOnlineAtion];
}


-(void)onFullScreenAction
{
    if(!_isFullScreen)
    {
        NSArray<TuSDKPFStickerItemView *> *arr = self.stickerView.subviews;
        [arr enumerateObjectsUsingBlock:^(TuSDKPFStickerItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.sticker.categoryId == 3)
            {
                UIImage *image = [self.inputImage copy];
                
                //        image = [UIImage imageCompressForSize:image targetSize:CGSizeMake(1200, 1200)];
                //        obj.imageView.image = [UIImage imageCompressForSize:obj.imageView.image targetSize:image.size];
                UIImage *image2 = [UIImage reSizeImage:obj.imageView.image toSize:image.size];
                obj.imageView.contentMode = UIViewContentModeScaleAspectFit;
                obj.imageView.clipsToBounds = YES;
                obj.hidden = YES;
                [self.defaultStyleView setImage: [UIImage addImage:image withImage:image2]];
                *stop = YES;
            }
        }];
    }
    else
    {
        NSArray<TuSDKPFStickerItemView *> *arr = self.stickerView.subviews;
        [arr enumerateObjectsUsingBlock:^(TuSDKPFStickerItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
        }];
        [self.defaultStyleView setImage: self.inputImage];
    }
//    [self.defaultStyleView setImage:[UIImage blurryImage:self.defaultStyleView.imageView.image withBlurLevel:1]];
    _isFullScreen = !_isFullScreen;
    [self.fullScreen setSelected:_isFullScreen];
    self.blur.enabled = !_isFullScreen;
    
}

-(void)onBlurAction
{
    if(!_isBlured)
    {
        NSArray<TuSDKPFStickerItemView *> *arr = self.stickerView.subviews;
        [arr enumerateObjectsUsingBlock:^(TuSDKPFStickerItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.sticker.categoryId == 3)
            {
                UIImage *image = [self.inputImage copy];
                image = [UIImage imageCompressForSize:image targetSize:CGSizeMake(1200, 1200)];
                obj.imageView.image = [UIImage imageCompressForSize:obj.imageView.image targetSize:CGSizeMake(1200, 1200)];
                obj.imageView.contentMode = UIViewContentModeScaleAspectFill;
                obj.imageView.clipsToBounds = YES;
                obj.imageView.image = [UIImage addImage:image withImage:obj.imageView.image];
                *stop = YES;
            }
        }];
        [self.defaultStyleView setImage:[UIImage blurryImage:self.defaultStyleView.imageView.image withBlurLevel:1]];
    }
    else
    {
        NSArray<TuSDKPFStickerItemView *> *arr = self.stickerView.subviews;
        [arr enumerateObjectsUsingBlock:^(TuSDKPFStickerItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            obj.cancelButton;
            
            if(obj.sticker.categoryId == 3)
            {
                [obj performSelector:@selector(handleCancelButton) withObject:obj.cancelButton afterDelay:0];
//                [obj removeFromSuperview];
                [self appendSticker:obj.sticker];
                *stop = YES;
            }
        }];
         [self.defaultStyleView setImage: self.inputImage];
    }
    _isBlured = !_isBlured;
    [self.blur setSelected:_isBlured];
    self.fullScreen.enabled = !_isBlured;
//    CGRect rect = [UIImage getFrameSizeForImage:self.defaultStyleView.imageView.image inImageView:self.defaultStyleView.imageView];
//    self.defaultStyleView.imageView.image = [self ScreenShotWithRect:rect];
}



-(void)stickerTableView:(TuSDKPFStickerTableView *)view selectedData:(TuSDKPFSticker *)data indexPath:(NSIndexPath *)indexPath
{
    if(data.categoryId==3){
        NSArray *arr = [self.stickerView resultsWithRegionRect:self.stickerView.frame];
        for(int i=0;i<arr.count;i++)
        {
            TuSDKPFStickerResult *result = arr[i];
            if(result.sticker.categoryId==3)
            {
                [self showHubErrorWithStatus:@"相框只可选择一个"];
                return;
            }
        }
        data.size = _stickSize;
    }
    [self.stickerView appenSticker:data];
    
}


-(UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2
{
    
    UIGraphicsBeginImageContext(image1.size);
    
    //Draw image2
//    [image2 drawInRect:CGRectMake(-(image2.size.width-image2.size.height)/2, 0, image2.size.width, image2.size.height)];
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    //Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}


-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(UIImage *)ScreenShotWithRect:(CGRect)r
{
    CGRect rect =self.view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    float originX ;
    float originy ;
    float width ;
    float height ;
    //你需要的区域起点,宽,高;
    
    CGRect rect1 = r;//CGRectMake(originX , originY , width , height);
    UIImage * imgeee = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([img CGImage], rect1)];
    return imgeee;
}

@end
