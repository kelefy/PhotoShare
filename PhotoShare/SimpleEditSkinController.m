//
//  SimpleEditSkinController.m
//  PhotoShare
//
//  Created by kongfanyi on 16/7/31.
//  Copyright © 2016年 dd. All rights reserved.
//

#import "SimpleEditSkinController.h"
#import "UIColor+Puertorico.h"
#import "UIColor+Viking.h"
#import "UIColor+Silversand.h"
#import "UIView+Extension.h"

@implementation SimpleEditSkinController

-(void)configDefaultStyleView:(TuSDKCPFilterResultView *)view
{
    [super configDefaultStyleView:view];
    
    UIButton *left = [UIButton buttonWithFrame:CGRectMake(0, 0, 70, 70) imageName:@"TuSDK.bundle/ui_default/style_default_edit_button_cancel_bg"];
    [left addTarget:self action:@selector(leftText) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:left];
    
    UIButton *right = [UIButton buttonWithFrame:CGRectMake(view.width-70, 0, 70, 70) imageName:@"TuSDK.bundle/ui_default/style_default_edit_button_confirm_bg"];
    [right addTarget:self action:@selector(onImageCompleteAtion) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:right];
    
    view.configView.backgroundColor = [UIColor puertoRico];
    view.bottomBar.backgroundColor = [UIColor viking];
//    view.configView.y += view.bottomBar.height;
    
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj isKindOfClass:[TuSDKICFilterImageViewWrap class]]) //图片背景
        {
//            obj.height += view.bottomBar.height;
            obj.backgroundColor = [UIColor silverSand];
//            *stop = YES;
        }
        else if(idx==3||idx==4)
        {
            obj.backgroundColor = [UIColor viking];
            
            //取消滚动条
            if([obj isKindOfClass:[TuSDKPFEditAdjustOptionBar class]])
            {
                TuSDKPFEditAdjustOptionBar *bar = (TuSDKPFEditAdjustOptionBar *)obj;
                bar.wrapView.showsHorizontalScrollIndicator = NO;
            }
        }
    }];
    
}

-(void)leftText
{
    [self performSelector:@selector(backActionHadAnimated)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBarHidden:YES];
}

@end
