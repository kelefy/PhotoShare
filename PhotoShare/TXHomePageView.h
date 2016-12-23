//
//  XTHomePageView.h
//  Etion
//
//  Created by cracker on 15/8/29.
//  Copyright (c) 2015年 GuangZhouXuanWu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomePageDelegate <NSObject>

@required
-(void)skipButtonDidClick;

@end

@interface TXHomePageView : UIView<UIScrollViewDelegate>

@property(nonatomic,weak) id<HomePageDelegate> delegate;
@property(nonatomic,strong) UIScrollView *mainScrollView;
@property(nonatomic,strong) UIPageControl *pageControl;
@property(nonatomic,strong) UIButton *skipButton;

@end
