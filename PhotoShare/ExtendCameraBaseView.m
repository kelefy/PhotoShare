//
//  ExtendCameraBaseView.m
//  PhotoShare
//
//  Created by kongfanyi on 16/7/17.
//  Copyright © 2016年 dd. All rights reserved.
//

#import "ExtendCameraBaseView.h"
#import "UIView+Extension.h"
#import "UIColor+Viking.h"

@implementation ExtendCameraBaseView

- (void)lsqInitView
{
    [super lsqInitView];
    
    
    // 更开默认相机控制栏视图的属性
//    [_configBar setSizeHeight:44];
    
    _configBar.backgroundColor = [UIColor clearColor];
    _configBar.closeButton.hidden = YES;
    
    // 更改闪光灯视图的属性
//    [_flashView setFlashFrame:_configBar.flashButton.frame];
    [self buildBottomBar];
    
    self.displayView.height -=  self.bottomBar.height;
}


-(void)buildBottomBar
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-80, self.width, 80)];
    view.backgroundColor = [UIColor viking];
    [self addSubview:view];
    [self.bottomBar buildFilterButton];
    self.bottomBar.filterButton.hidden = YES;
    [self.bottomBar buildAlbumButton];
    self.bottomBar.albumPoster.frame = self.bottomBar.filterButton.frame;
    
    self.bottomBar.captureButton.frame = CGRectMake((self.width-60)/2.f, 10, 60, 60);
    
    [self.bottomBar.captureButton setBackgroundImage:[UIImage imageNamed:@"shutter"] forState:UIControlStateNormal];
    
    [view addSubview:self.bottomBar.captureButton];
    
//    self.bottomBar.albumPoster.frame = CGRectMake(self.width/2.f+(self.width/2.f-40)/2, 20, 60, 60);
    self.bottomBar.albumPoster.width -= 10;
    self.bottomBar.albumPoster.height -= 10;
    self.bottomBar.albumPoster.y += 5;
    self.bottomBar.albumPoster.layer.borderWidth = 3;
    self.bottomBar.albumPoster.layer.borderColor = [[UIColor whiteColor]CGColor];
    [view addSubview:self.bottomBar.albumPoster];
    
}

-(void)layoutSubviews
{
    
}

@end
