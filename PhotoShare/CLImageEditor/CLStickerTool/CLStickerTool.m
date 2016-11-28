//
//  CLStickerTool.m
//
//  Created by sho yakushiji on 2013/12/11.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLStickerTool.h"

#import "CLCircleView.h"
#import "UIImage+blurryImage.h"
#import "UIColor+Silversand.h"
#import "UIColor+Viking.h"
#import "UIView+Extension.h"
#import "UIColor+Hex.h"
#import "UIColor+Puertorico.h"


static NSString* const kCLStickerToolStickerPathKey = @"stickerPath";
static NSString* const kCLStickerToolDeleteIconName = @"deleteIconAssetsName";

@interface _CLStickerView : UIView
@property (nonatomic,copy) UIImage *originalImage;
@property (copy) void(^OnBlurButtonClickBlock)(_CLStickerView*);
@property (copy) void(^OnFullButtonClickBlock)(_CLStickerView*);
@property (copy) void(^OnDeleteButtonClickBlock)(_CLStickerView*);
@property (nonatomic,assign) BOOL isxk;
+ (void)setActiveStickerView:(_CLStickerView*)view;
- (UIImageView*)imageView;
//- (id)initWithImage:(UIImage *)image tool:(CLStickerTool*)tool;
- (id)initWithImage:(UIImage *)image tool:(CLStickerTool*)tool isXiangKuang:(BOOL)isXiangKuang;
- (void)setScale:(CGFloat)scale;
-(CGFloat)arg;
-(CGFloat)scale;
@end




@implementation CLStickerTool
{
    UIImage *_originalImage;
    
    UIView *_workingView;
    
    UIScrollView *_menuScroll;
    
    UIScrollView *_stickerScroll;
    
    __weak UIButton *_xkButton;
    
    __weak UIButton *_stickerButton;
    
    BOOL _hadBlur;
    
    BOOL _hadFullScreen;
    
    __weak UIView *_gestureView;
    __weak UIImageView *_stickImageView;
    
    __weak UIButton *_leftButton;
    __weak UIButton *_rightButton;
    
    CGRect _blurFrame;
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return [CLImageEditorTheme localizedString:@"CLStickerTool_DefaultTitle" withDefault:@"Sticker"];
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 7;
}

#pragma mark- optional info

+ (NSString*)defaultStickerPath
{
    return [[[CLImageEditorTheme bundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/stickers", NSStringFromClass(self)]];
}

+ (NSDictionary*)optionalInfo
{
    return @{
             kCLStickerToolStickerPathKey:[self defaultStickerPath],
             kCLStickerToolDeleteIconName:@"",
             };
}

#pragma mark- implementation

- (void)setup
{
    _originalImage = self.editor.imageView.image;
    self.editor.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.y += 27;
    _menuScroll.height -= 27;
    _menuScroll.backgroundColor = [UIColor viking];//self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_menuScroll];
    
    
    _stickerScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _stickerScroll.y += 27;
    _stickerScroll.height -= 27;
    _stickerScroll.backgroundColor = [UIColor viking];//self.editor.menuView.backgroundColor;
    _stickerScroll.showsHorizontalScrollIndicator = NO;
     [self.editor.view addSubview:_stickerScroll];
    
    UIView *parasView = [[UIView alloc]initWithFrame:CGRectMake(_menuScroll.x, _menuScroll.y-27, _menuScroll.width, 27)];
    parasView.backgroundColor = [UIColor viking];
    
    UIButton *xkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [xkButton setTitle:@"相框" forState:UIControlStateNormal];
    [xkButton setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [xkButton setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateSelected];
    xkButton.titleLabel.font = [UIFont systemFontOfSize:12];
    xkButton.frame = CGRectMake(0, 0, parasView.width/2, 27);
    [xkButton addTarget:self action:@selector(tapStickCatoryButton:) forControlEvents:UIControlEventTouchUpInside];
    [parasView addSubview:xkButton];
    _xkButton = xkButton;
    
    UIButton *stickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [stickerButton setTitle:@"贴纸" forState:UIControlStateNormal];
    [stickerButton setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [stickerButton setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateSelected];
    stickerButton.titleLabel.font = [UIFont systemFontOfSize:12];
    stickerButton.frame = CGRectMake(_menuScroll.width/2, 0, parasView.width/2, 27);
    [stickerButton addTarget:self action:@selector(tapStickCatoryButton:) forControlEvents:UIControlEventTouchUpInside];
    [parasView addSubview:stickerButton];
    _stickerButton = stickerButton;
    
    [self.editor.view addSubview:parasView];
    
    _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
    _workingView.clipsToBounds = YES;
    [self.editor.view addSubview:_workingView];
    
    UIGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView)];
    [self.editor.view addGestureRecognizer:singleTap];
    
    [self setStickerMenu];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }];
    
    [self tapStickCatoryButton:_xkButton];
    
}

-(void)tapImageView
{
     [_CLStickerView setActiveStickerView:nil];
}

- (void)cleanup
{
    [self.editor resetZoomScaleWithAnimated:YES];
    
    [_workingView removeFromSuperview];
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                     }
                     completion:^(BOOL finished) {
                         [_menuScroll removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    _originalImage = self.editor.imageView.image;
    [_CLStickerView setActiveStickerView:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage:_originalImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

-(void)cleanFullScreen
{
    [_gestureView removeFromSuperview];
    [_stickImageView removeFromSuperview];
}

#pragma mark-

-(void)tapStickCatoryButton:(UIButton *)btn
{
    [btn setSelected:YES];
    if(btn == _xkButton)
    {
        [_stickerButton setSelected:NO];
        [self.editor.view bringSubviewToFront:_menuScroll];
    }
    else
    {
        [_xkButton setSelected:NO];
        [self.editor.view bringSubviewToFront:_stickerScroll];
    }
}

- (void)setStickerMenu
{
    CGFloat W = 65;
    CGFloat H = _menuScroll.height;
    CGFloat x = 15;
    
    NSString *stickerPath = self.toolInfo.optionalInfo[kCLStickerToolStickerPathKey];
    if(stickerPath==nil){ stickerPath = [[self class] defaultStickerPath]; }
    
    stickerPath = [stickerPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",1]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray *list = [fileManager contentsOfDirectoryAtPath:stickerPath error:&error];
    
    for(NSString *path in list){
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", stickerPath, path];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if(image){
            CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, 50, 50) target:self action:@selector(tappedStickerPanel:) toolInfo:nil];
            view.iconView.layer.cornerRadius = 0;
            view.iconView.x+=5;
            view.iconView.width-=10;
            view.iconView.height-=10;
            view.iconView.y+=5;
            view.layer.cornerRadius = view.height/2.f;
            view.clipsToBounds = YES;
            view.backgroundColor = [UIColor colorWithHex:0x6ed5d5];
            view.iconView.contentMode = UIViewContentModeScaleAspectFit;
//            view.iconImage = [image aspectFit:CGSizeMake(50*[[UIScreen mainScreen]scale], 50*[[UIScreen mainScreen]scale])];
            view.iconImage = [image imageCompressForWidth:50*[[UIScreen mainScreen]scale]];
            view.userInfo = @{@"filePath" : filePath};
            
            [_menuScroll addSubview:view];
            x += W;
        }
    }
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
    
    UIButton *left = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    [left setBackgroundImage:[UIImage imageNamed:@"TuSDK.bundle/ui_default/style_default_edit_button_cancel_bg"] forState:UIControlStateNormal];
    //    [UIButton buttonWithFrame:CGRectMake(0, 0, 70, 70) imageName:@"TuSDK.bundle/ui_default/style_default_edit_button_cancel_bg"];
    [left addTarget:self.editor action:@selector(pushedCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.editor.view addSubview:left];
    _leftButton = left;
    
    UIButton *right = [[UIButton alloc]initWithFrame:CGRectMake(self.editor.view.width-70, 0, 70, 70)];
    //    [UIButton buttonWithFrame:CGRectMake(view.width-70, 0, 70, 70) imageName:@"TuSDK.bundle/ui_default/style_default_edit_button_confirm_bg"];
    [right setBackgroundImage:[UIImage imageNamed:@"TuSDK.bundle/ui_default/style_default_edit_button_confirm_bg"] forState:UIControlStateNormal];
    [right addTarget:self.editor action:@selector(pushedFinishBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.editor.view addSubview:right];
    _rightButton = right;
    self.editor.view.backgroundColor = [UIColor silverSand];
    
    
    
    

    NSString *stickerPath2 = self.toolInfo.optionalInfo[kCLStickerToolStickerPathKey];
    if(stickerPath2==nil){ stickerPath = [[self class] defaultStickerPath]; }

    stickerPath2 = [stickerPath2 stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",2]];
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    
//    NSError *error = nil;
    NSArray *listSticker = [fileManager contentsOfDirectoryAtPath:stickerPath2 error:&error];
    x=15;
    for(NSString *path in listSticker){
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", stickerPath2, path];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if(image){
            CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, 50, 50) target:self action:@selector(tappedStickerPanel:) toolInfo:nil];
            view.iconView.layer.cornerRadius = 0;
            view.layer.cornerRadius = view.height/2.f;
            view.clipsToBounds = YES;
            view.backgroundColor = [UIColor colorWithHex:0x6ed5d5];
            view.iconView.contentMode = UIViewContentModeScaleAspectFit;
            view.iconImage = [image aspectFit:CGSizeMake(50*[[UIScreen mainScreen]scale], 50*[[UIScreen mainScreen]scale])];
            view.userInfo = @{@"filePath" : filePath};
            
            [_stickerScroll addSubview:view];
            x += W;
        }
    }
    _stickerScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);

}

- (void)tappedStickerPanel:(UITapGestureRecognizer*)sender
{
    NSArray *arr = _workingView.subviews;//所有贴纸相框
    
    
    
    UIView *view = sender.view;//点击的贴纸
    
    NSString *filePath = view.userInfo[@"filePath"];
    
    if(filePath){ //是否相框
        //如果点击相框
        BOOL isXiangKuang = [filePath containsString:@"/1/"];
        
        NSMutableArray<_CLStickerView *> *tempStickerArr = [NSMutableArray arrayWithCapacity:arr.count];
        
        _CLStickerView *view = [[_CLStickerView alloc] initWithImage:[UIImage imageWithContentsOfFile:filePath] tool:self isXiangKuang:isXiangKuang];
        
        if(isXiangKuang)
        {
            for(int i = 0;i<arr.count;i++)
            {
                if([arr[i] isKindOfClass:[_CLStickerView class]])
                {
                    _CLStickerView *cl = arr[i];
                    if(cl.isxk)
                    {
//                        [self.editor.simpleEditMultipleController showHubErrorWithStatus:@"相框只可选择一个"];
                        [cl removeFromSuperview]; //移除原来相框
                    }
                    else
                    {
                        [tempStickerArr addObject:cl];
                    }
                }
            }
            
            CGFloat ratio = MIN( (0.68 * _workingView.width) / view.width, (0.68 * _workingView.height) / view.height);
            [view setScale:ratio];
            
            _blurFrame = view.frame;
            _blurFrame.size.width -= 32;
            _blurFrame.size.height -= 32;
            
            

        }
        
        else
        {
            CGFloat ratio = MIN( (0.35 * _workingView.width) / view.width, (0.35 * _workingView.height) / view.height);
            [view setScale:ratio];
        }
        
        view.center = CGPointMake(_workingView.width/2, _workingView.height/2);
        
        
        if(_hadFullScreen&&view.isxk)
        {//取消全屏相框
            
            _hadFullScreen = !_hadFullScreen;
            
            [self cleanFullScreen];
            
            self.editor.imageView.image = _originalImage;
            
            [self.editor setImageViewFrame];
            
            _workingView.frame = [self.editor.imageView.image getFrameinImageView:self.editor.imageView];
        }
        else if(_hadBlur&&view.isxk)
        {
            self.editor.imageView.image = _originalImage;
            _hadBlur = !_hadBlur;
            [_workingView removeAllSubviews];
            [tempStickerArr enumerateObjectsUsingBlock:^(_CLStickerView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [_workingView addSubview:obj];
            }];
        }
        
        
        
        //虚化
        view.OnBlurButtonClickBlock = ^(_CLStickerView *_CLStickerView){
            
            if(!_hadBlur)
            {
//                UIImage *img1 = [UIImage imageCompressForSize:_originalImage targetSize:_CLStickerView.imageView.image.size];
//                _CLStickerView.imageView.image = [UIImage addImage:img1 withImage:_CLStickerView.imageView.image];
                
                
                UIView *workView = [[UIView alloc]initWithFrame:_CLStickerView.frame];
//                workView.backgroundColor = [UIColor whiteColor];
                workView.clipsToBounds = YES;
                workView.frame = _blurFrame;
                workView.center = CGPointMake(_workingView.width/2, _workingView.height/2);
                [_workingView addSubview:workView];
                
                //原图
                UIImageView *backgroundImgView = [[UIImageView alloc]initWithImage:_originalImage];
                backgroundImgView.contentMode = UIViewContentModeScaleAspectFill;
                backgroundImgView.frame = CGRectMake(0, 0, workView.width, workView.height);
                
                //            backgroundImgView.center = _workingView.center;
                [workView addSubview:backgroundImgView];
                _gestureView = backgroundImgView;
                
                
                
                //贴纸图片
                UIImageView *stickImageView = [[UIImageView alloc]initWithImage:_CLStickerView.originalImage];
                //            stickImageView.contentMode = UIViewContentModeScaleAspectFit;
                //            stickImageView.backgroundColor = [UIColor whiteColor];
                stickImageView.frame = _CLStickerView.frame;
                _stickImageView = stickImageView;
                _stickImageView.frame = _blurFrame;
                _stickImageView.center = CGPointMake(_workingView.width/2, _workingView.height/2);
                [_workingView addSubview:stickImageView];
                
                [self addGestureRecognizerToView:stickImageView];
                stickImageView.userInteractionEnabled = YES;
                stickImageView.multipleTouchEnabled = YES;
                
//                workView.transform = CGAffineTransformMakeRotation(5);
//                stickImageView.transform = CGAffineTransformMakeRotation(5);
                
//                workView.transform = CGAffineTransformMakeScale(_CLStickerView.scale, _CLStickerView.scale);
//                stickImageView.transform = CGAffineTransformMakeScale(_CLStickerView.scale, _CLStickerView.scale);
                
//                [_workingView bringSubviewToFront:_CLStickerView];
//                [self addGestureRecognizerToView:_CLStickerView];
                
                
                
                self.editor.imageView.image = [UIImage blurryImage:_originalImage withBlurLevel:1];
                
                [_CLStickerView removeFromSuperview];
            }
            else
            {
                self.editor.imageView.image = _originalImage;
                _CLStickerView.imageView.image = _CLStickerView.originalImage;
            }
            
            _hadBlur = !_hadBlur;
        };
        
        view.OnDeleteButtonClickBlock = ^(_CLStickerView *_CLStickerView){
            if(_hadBlur)
            {
                self.editor.imageView.image = _originalImage;
                _CLStickerView.imageView.image = _CLStickerView.originalImage;
                _hadBlur = !_hadBlur;
            }
        };
        
        view.OnFullButtonClickBlock = ^(_CLStickerView *_clStickerView){
            
//            __weak
            //全屏相框状态
            _hadFullScreen = YES;
            
            //取消虚化
            if(_hadBlur)
            {
                _clStickerView.OnBlurButtonClickBlock(_clStickerView);
            }
            
            //更改imageview Frame
            self.editor.imageView.frame = CGRectMake(0, 0, self.editor.view.width, self.editor.view.height-80);
            
            UIImage *fullSticker;
            
            CGFloat scale = 3;//[[UIScreen mainScreen]scale];
            
            if(_clStickerView.imageView.image.size.height>_clStickerView.size.width)
            {
//                fullSticker = [_CLStickerView.imageView.image imageCompressForWidth:self.editor.view.width*scale];
                fullSticker = [_clStickerView.imageView.image imageCompressForWidth:_originalImage.size.width];
            }
            else
            {
//               fullSticker = [UIImage imageCompressForSize:_CLStickerView.imageView.image targetSize:CGSizeMake(self.editor.view.size.width*scale,self.editor.view.size.height*scale)];
                fullSticker = [UIImage imageCompressForSize:_clStickerView.imageView.image targetSize:CGSizeMake(_originalImage.size.width,_originalImage.size.height)];
            }
            
            UIImage *fullOriImg = [UIImage imageCompressForSize:self.editor.imageView.image targetSize:fullSticker.size];
            
//            UIImage *img1 = [UIImage imageCompressForSize:self.editor.imageView.image targetSize:_CLStickerView.imageView.image.size];
            
//            img1 = [UIImage addImage:img1 withImage:_CLStickerView.imageView.image];
            
             UIImage *img1 = [UIImage addImage:fullOriImg withImage:fullSticker];
            
            UIImage *fullImg;
            
            if(img1.size.width>img1.size.height)
            {
                fullImg = [img1 imageCompressForWidth:self.editor.view.width*scale];
                
                //修复框横问题
                _workingView.width = self.editor.view.width;
                _workingView.x = 0;
            }
            else
            {
                fullImg = [UIImage imageCompressForSize:img1 targetSize:CGSizeMake(self.editor.view.size.width*scale,self.editor.view.size.height*scale)];
            }
            //            self.editor.imageView.image = fullImg;
            self.editor.imageView.image = fullSticker;
            _workingView.frame = [self.editor.imageView.image getFrameinImageView:self.editor.imageView];
            
            _clStickerView.hidden = YES;
            
            //原图
            UIImageView *backgroundImgView = [[UIImageView alloc]initWithImage:_originalImage];
            backgroundImgView.contentMode = UIViewContentModeScaleAspectFill;
            backgroundImgView.frame = CGRectMake(0, 0, _workingView.width, _workingView.height);
//            backgroundImgView.center = _workingView.center;
            [_workingView addSubview:backgroundImgView];
            _gestureView = backgroundImgView;
            
            
            //贴纸图片
            UIImageView *stickImageView = [[UIImageView alloc]initWithImage:fullSticker];
//            stickImageView.contentMode = UIViewContentModeScaleAspectFit;
//            stickImageView.backgroundColor = [UIColor whiteColor];
            stickImageView.frame = CGRectMake(0, 0, _workingView.width, _workingView.height);
            _stickImageView = stickImageView;
            [_workingView addSubview:stickImageView];
            
            [self addGestureRecognizerToView:stickImageView];
            stickImageView.userInteractionEnabled = YES;
            stickImageView.multipleTouchEnabled = YES;
            
            [self bringSticksToFront];
        };
        
        [_workingView addSubview:view];
        [_CLStickerView setActiveStickerView:view];
        
        
    }
    
    view.alpha = 0.2;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }
     ];
}

-(void)bringSticksToFront
{
    //加载原来的贴纸
    [_workingView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[_CLStickerView class]])
        {
            _CLStickerView *clsticker = (_CLStickerView*)obj;
            if(![clsticker isxk])
            {
                [_workingView bringSubviewToFront:clsticker];
//                [_workingView addSubview:clsticker];
            }
        }
    }];
}

- (UIImage*)buildImage:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    [image drawAtPoint:CGPointZero];
    
    CGFloat scale = image.size.width / _workingView.width;
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    [_workingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

//imageView手势

// 添加所有的手势
- (void) addGestureRecognizerToView:(UIView *)view
{
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [view addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
}

// 处理旋转手势
- (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = _gestureView;//rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = _gestureView;//pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = _gestureView;//panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

@end



@implementation _CLStickerView
{
    UIImageView *_imageView;
    UIButton *_deleteButton;
//    CLCircleView *_circleView;
    UIButton *_blurButton;
    UIButton *_fullButton;
    
    UIButton *_circleButton;
    
    CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
}

+ (void)setActiveStickerView:(_CLStickerView*)view
{
    static _CLStickerView *activeView = nil;
    if(view != activeView){
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
        
        [activeView.superview bringSubviewToFront:activeView];
    }
}

- (id)initWithImage:(UIImage *)image tool:(CLStickerTool*)tool isXiangKuang:(BOOL)isXiangKuang
{
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width+32, image.size.height+32)];
    if(self){
        self.originalImage = image;
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _imageView.layer.cornerRadius = 3;
        _imageView.center = self.center;
        [self addSubview:_imageView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
        [_deleteButton setImage:[UIImage imageNamed:@"circle_orange"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 32, 32);
//        _deleteButton.center = CGPointMake(_imageView.frame.origin.x, _imageView.height + _imageView.frame.origin.y);
        _deleteButton.center = _imageView.frame.origin;
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
//        _circleView = [[CLCircleView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
//        _circleView.center = CGPointMake(_imageView.width + _imageView.frame.origin.x, _imageView.height + _imageView.frame.origin.y);
//        _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
//        _circleView.radius = 0.7;
//        _circleView.color = [UIColor whiteColor];
//        _circleView.borderColor = [UIColor whiteColor];
//        _circleView.borderWidth = 5;
//
        
        _circleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _circleButton.center = CGPointMake(_imageView.width + _imageView.frame.origin.x, _imageView.height + _imageView.frame.origin.y);
        _circleButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
//        _circleButton.layer.radius = 0.7;
//        _circleView.color = [UIColor whiteColor];
//        _circleButton.layer.borderColor = [UIColor whiteColor];
//        _circleButton.layer.borderWidth = 5;
        [_circleButton setBackgroundImage:[UIImage imageNamed:@"circle_blue"] forState:UIControlStateNormal];
        
        [self addSubview:_circleButton];
        
        if(isXiangKuang)
        {
            self.isxk = isXiangKuang;
            
            _blurButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_blurButton setImage:[UIImage imageNamed:@"bokeh"] forState:UIControlStateNormal];
            _blurButton.frame = CGRectMake(0, 0, 32, 32);
            _blurButton.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1);
            _blurButton.backgroundColor = [UIColor colorWithHex:0x3AC6FB];
            _blurButton.clipsToBounds = YES;
            _blurButton.layer.cornerRadius = 16;
            _blurButton.center = CGPointMake(_imageView.frame.origin.x, _imageView.height + _imageView.frame.origin.y);
            _blurButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
            [_blurButton addTarget:self action:@selector(pushedBlurBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_blurButton];
            
            _fullButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_fullButton setImage:[UIImage imageNamed:@"maximize"] forState:UIControlStateNormal];
            _fullButton.frame = CGRectMake(0, 0, 32, 32);
            _fullButton.backgroundColor = [UIColor colorWithHex:0x3AC6FB];
            _fullButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            _fullButton.clipsToBounds = YES;
            _fullButton.layer.cornerRadius = 16;
            _fullButton.center = CGPointMake(_imageView.frame.origin.x+_imageView.frame.size.width,_imageView.frame.origin.y);
            _fullButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [_fullButton addTarget:self action:@selector(pushedFullBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_fullButton];

        }

        
        _scale = 1;
        _arg = 0;
        
        [self initGestures];
    }
    return self;
}

- (void)initGestures
{
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    [_imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
//    [_circleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
    [_circleButton addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view= [super hitTest:point withEvent:event];
    if(view==self){
        return nil;
    }
    return view;
}

- (UIImageView*)imageView
{
    return _imageView;
}

-(void)pushedBlurBtn:(id)sender
{
    if(self.OnBlurButtonClickBlock)
        self.OnBlurButtonClickBlock(self);
}

-(void)pushedFullBtn:(id)sender
{
    if(self.OnFullButtonClickBlock)
        self.OnFullButtonClickBlock(self);
}

- (void)pushedDeleteBtn:(id)sender
{
    _CLStickerView *nextTarget = nil;
    
    if(self.OnDeleteButtonClickBlock)
    {
        self.OnDeleteButtonClickBlock(self);
    }
    
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i=index+1; i<self.superview.subviews.count; ++i){
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[_CLStickerView class]]){
            nextTarget = (_CLStickerView*)view;
            break;
        }
    }
    
    if(nextTarget==nil){
        for(NSInteger i=index-1; i>=0; --i){
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[_CLStickerView class]]){
                nextTarget = (_CLStickerView*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveStickerView:nextTarget];
    [self removeFromSuperview];
}

- (void)setAvtive:(BOOL)active
{
    _deleteButton.hidden = !active;
//    _circleView.hidden = !active;
    _circleButton.hidden = !active;
    _blurButton.hidden = !active;
    _fullButton.hidden = !active;
    _imageView.layer.borderWidth = (active) ? 2/_scale : 0;
}

-(CGFloat)arg
{
    return _arg;
}

-(CGFloat)scale
{
    return _scale;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    self.transform = CGAffineTransformIdentity;
    
    _imageView.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_imageView.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_imageView.height + 32)) / 2;
    rct.size.width  = _imageView.width + 32;
    rct.size.height = _imageView.height + 32;
    self.frame = rct;
    
    _imageView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_arg);
    
    _imageView.layer.borderWidth = 2/_scale;
    
    _imageView.layer.cornerRadius = 3/_scale;
}

- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    [[self class] setActiveStickerView:self];
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveStickerView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}

- (void)circleViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1;
    static CGFloat tmpA = 0;
    if(sender.state == UIGestureRecognizerStateBegan){
//        _initialPoint = [self.superview convertPoint:_circleView.center fromView:_circleView.superview];
        _initialPoint = [self.superview convertPoint:_circleButton.center fromView:_circleButton.superview];
        
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y);
    CGFloat arg = atan2(p.y, p.x);
    
    _arg   = _initialArg + arg - tmpA;
    [self setScale:MAX(_initialScale * R / tmpR, 0.2)];
}



@end
