//
//  ExtendCameraConfigView.m
//  PhotoShare
//
//  Created by kongfanyi on 16/7/31.
//  Copyright © 2016年 dd. All rights reserved.
//

#import "ExtendCameraConfigView.h"

@implementation ExtendCameraConfigView

-(void)layoutSubviews
{
//    const NSInteger leftPadding = 25;
    NSInteger iconTotalLenth = [self.flashButton getSizeWidth]+[self.switchButton getSizeWidth]+[self.ratioButton getSizeWidth]+[self.guideLineButton getSizeWidth];
//    float space = ([self getSizeWidth]-iconTotalLenth-leftPadding*2)/3.f;
    float space = ([self getSizeWidth]-iconTotalLenth)/5.f;
    NSInteger w = space;
    [_ratioButton setOriginX:w];
    w+=[_ratioButton getSizeWidth]+space;
    [_guideLineButton setOriginX:w];
    w+=[_guideLineButton getSizeWidth]+space;
    [_flashButton setOriginX:w];
    w+=[_flashButton getSizeWidth]+space;
    [_switchButton setOriginX:w];
    
}

@end
