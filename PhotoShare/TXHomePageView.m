//
//  XTHomePageView.m
//  Etion
//
//  Created by cracker on 15/8/29.
//  Copyright (c) 2015年 GuangZhouXuanWu. All rights reserved.
//

#if !__has_feature(objc_arc)
#error ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "TXHomePageView.h"
#import "UIImage+ImageNotCached.h"
#import "UIColor+Viking.h"

@implementation TXHomePageView
{
    NSMutableArray *_arrScrollImages;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _arrScrollImages = [[NSMutableArray alloc]initWithCapacity:3];
    [self addSubview:self.mainScrollView];
    [self addSubview:self.pageControl];
//    [self.mainScrollView addSubview:self.skipButton];
    
    [_arrScrollImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imv = (UIImageView *)obj;
        UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [skipButton.layer setCornerRadius:7];
        [skipButton setTitleColor:[UIColor viking] forState:UIControlStateNormal];
        if(idx == _arrScrollImages.count-1)
        {
            [skipButton setTitle:@"立即体验" forState:UIControlStateNormal];
        }
        else
        {
            [skipButton setTitle:@"跳 过" forState:UIControlStateNormal];
        }
        skipButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [skipButton addTarget:self action:@selector(skipButtonClick) forControlEvents:UIControlEventTouchUpInside];
        skipButton.frame = CGRectMake(imv.frame.size.width/2-50, self.pageControl.frame.origin.y-28, 100, 30);
        skipButton.backgroundColor = [UIColor clearColor];
        [imv setUserInteractionEnabled:YES];
        [imv addSubview:skipButton];
    }];
    return self;
}

-(void)addImage:(NSString *)imageName
{
    UIImage *newImage;
    UIImageView *addImageView;
    UIImageView *lastImageView;
    CGRect newImageViewFrame;
    
    newImage = [UIImage ImageNotCached:imageName];
    
    if(!newImage)
        return;
    
    lastImageView = [_arrScrollImages lastObject];
    if(!lastImageView)
    {
        newImageViewFrame = [UIScreen mainScreen].bounds;
    }
    else
    {
        CGRect lastImageFrame = lastImageView.frame;
        newImageViewFrame = CGRectMake(lastImageFrame.origin.x+lastImageFrame.size.width, lastImageFrame.origin.y, lastImageFrame.size.width, lastImageFrame.size.height);
    }
    
    addImageView = [[UIImageView alloc]initWithImage:newImage];
    addImageView.frame = newImageViewFrame;
    [_arrScrollImages addObject:addImageView];
}

#pragma mark - getter&setter

-(UIScrollView *)mainScrollView
{
    if(!_mainScrollView)
    {
        CGRect mainRect = [UIScreen mainScreen].bounds;
        _mainScrollView = [[UIScrollView alloc]initWithFrame:mainRect];
        NSArray *arrImages = [[NSArray alloc]initWithObjects:@"HomePageImage1",@"HomePageImage2",@"HomePageImage3",nil];
        for(NSString * image in arrImages)
        {
            NSString *imagePath;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                imagePath = [NSString stringWithFormat:@"%@.png",image];
            }
            else
            {
                imagePath = [NSString stringWithFormat:@"%@_ipad.jpg",image];
            }
            [self addImage:imagePath];
        }
        for(UIImageView * imv in _arrScrollImages)
        {
            [self.mainScrollView addSubview:imv];
        }
        _mainScrollView.contentSize = CGSizeMake(_arrScrollImages.count*mainRect.size.width, mainRect.size.height);
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.bounces = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _mainScrollView;
}

-(UIPageControl *)pageControl
{
    if(!_pageControl)
    {
        CGRect mainRect = [UIScreen mainScreen].bounds;
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(mainRect.size.width/2-50, mainRect.size.height-40, 100, 37)];
        _pageControl.numberOfPages = _arrScrollImages.count;
        _pageControl.currentPage = 0;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = [UIColor viking];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    return _pageControl;
}

-(UIButton *)skipButton
{
    if(!_skipButton)
    {
        _skipButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_skipButton.layer setCornerRadius:7];
        [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_skipButton setTitle:@"立即体验" forState:UIControlStateNormal];
        [_skipButton addTarget:self action:@selector(skipButtonClick) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *lastImv = [_arrScrollImages lastObject];
        CGRect rect = lastImv.frame;
        _skipButton.frame = CGRectMake(rect.origin.x+rect.size.width/2-50, self.pageControl.frame.origin.y-40, 100, 30);
        _skipButton.backgroundColor = [UIColor clearColor];
    }
    return _skipButton;
}

-(void)skipButtonClick
{
    [self.delegate skipButtonDidClick];
//    [self removeFromSuperview];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint size = scrollView.contentOffset;
    int page = (size.x+self.frame.size.width*0.5)/self.frame.size.width;
    self.pageControl.currentPage = page;
//    if(page==self.pageControl.numberOfPages-1)
//    {
//        self.pageControl.hidden = YES;
//    }
//    else
//    {
//        self.pageControl.hidden = NO;
//    }
}

@end
