//
//  SimpleEditCuterController.m
//  PhotoShare
//
//  Created by kongfanyi on 16/8/23.
//  Copyright © 2016年 dd. All rights reserved.
//

#import "SimpleEditCuterController.h"
#import "UIColor+Puertorico.h"
#import "UIColor+Silversand.h"
#import "UIColor+Viking.h"
#import "UIView+Extension.h"

@implementation SimpleEditCuterController

-(void)configDefaultStyleView:(TuSDKPFEditCuterView *)view
{
    [super configDefaultStyleView:view];
    view.optionBar.backgroundColor = [UIColor puertoRico];
    view.bottomBar.backgroundColor = [UIColor viking];
    view.backgroundColor = [UIColor silverSand];
    
    
    
    view.bottomBar.hidden = YES;
    view.optionBar.hidden = YES;
    view.optionBar.y+=view.bottomBar.height;
    view.imageView.height+=view.bottomBar.height;
    view.imageView.imageView.height+=view.bottomBar.height;
//    view.imageView.cutRegionView.height+=view.bottomBar.height;
    [view.imageView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       obj.height +=view.bottomBar.height;
    }];
    
    UIButton *left = [UIButton buttonWithFrame:CGRectMake(0, 0, 70, 70) imageName:@"TuSDK.bundle/ui_default/style_default_edit_button_cancel_bg"];
    [left addTarget:self action:@selector(backActionHadAnimated) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:left];
    
    UIButton *right = [UIButton buttonWithFrame:CGRectMake(view.width-70, 0, 70, 70) imageName:@"TuSDK.bundle/ui_default/style_default_edit_button_confirm_bg"];
    [right addTarget:self action:@selector(onImageCompleteAtion) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:right];
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:view.optionBar.frame];
    scroll.backgroundColor = [UIColor puertoRico];
    [view.optionBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [scroll addSubview:obj];
    }];
    UIButton *btn1 = view.optionBar.buttons[0];
    UIButton *btn2 = view.optionBar.buttons[1];
    UIButton *lastBtn = [view.optionBar.buttons lastObject];
    view.bottomBar.trunButton.frame = CGRectMake(lastBtn.x+btn2.x-btn1.x, (view.optionBar.height-view.bottomBar.trunButton.height)/2-5, view.bottomBar.trunButton.width, view.bottomBar.trunButton.height);
    [scroll addSubview:view.bottomBar.trunButton];
    view.bottomBar.mirrorButton.frame = CGRectMake(view.bottomBar.trunButton.x+btn2.x-btn1.x, (view.optionBar.height-view.bottomBar.mirrorButton.height)/2-5, view.bottomBar.mirrorButton.width, view.bottomBar.mirrorButton.height);
    [scroll addSubview:view.bottomBar.mirrorButton];
    scroll.contentSize = CGSizeMake(view.bottomBar.mirrorButton.x+view.bottomBar.mirrorButton.width+btn1.x, view.optionBar.height);
    [view addSubview:scroll];
}

@end
