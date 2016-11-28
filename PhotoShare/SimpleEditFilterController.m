//
//  SimpleEditFilterController.m
//  PhotoShare
//
//  Created by kongfanyi on 16/7/31.
//  Copyright © 2016年 dd. All rights reserved.
//

#import "SimpleEditFilterController.h"
#import "UIColor+Puertorico.h"
#import "UIColor+Viking.h"
#import "UIColor+Silversand.m"
#import "UIView+Extension.h"	

@implementation SimpleEditFilterController

-(void)configDefaultStyleView:(TuSDKPFEditFilterView *)view
{
    [super configDefaultStyleView:view];
    view.bottomBar.backgroundColor = [UIColor viking];
    view.imageView.height += view.bottomBar.height;
    
    //参数栏底色
    view.filterBar.bottomBar.backgroundColor = [UIColor viking];
    view.filterBar.configView.backgroundColor = [UIColor viking];
//    view.filterBar.configView.backgroundColor = [UIColor silverSand];
//    view.filterBar.bottomBar.backgroundColor = [UIColor puertoRico];
    
    UIButton *left = [UIButton buttonWithFrame:CGRectMake(0, 0, 70, 70) imageName:@"TuSDK.bundle/ui_default/style_default_edit_button_cancel_bg"];
    [left addTarget:self action:@selector(backActionHadAnimated) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:left];
    
    UIButton *right = [UIButton buttonWithFrame:CGRectMake(view.width-70, 0, 70, 70) imageName:@"TuSDK.bundle/ui_default/style_default_edit_button_confirm_bg"];
    [right addTarget:self action:@selector(onImageCompleteAtion) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:right];
    
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj isKindOfClass:[TuSDKICFilterImageViewWrap class]])
        {
            obj.backgroundColor = [UIColor silverSand];
            *stop = YES;
        }
    }];
    
    [view.filterBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj isKindOfClass:[TuSDKCPGroupFilterBar class]])
        {
            obj.y += view.bottomBar.height;
            obj.backgroundColor = [UIColor puertoRico];
            *stop = YES;
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBarHidden:YES];
}

@end
