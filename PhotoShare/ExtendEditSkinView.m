//
//  ExtendEditSkinView.m
//  PhotoShare
//
//  Created by kongfanyi on 16/8/24.
//  Copyright © 2016年 dd. All rights reserved.
//

#import "ExtendEditSkinView.h"

@implementation ExtendEditSkinView

-(void)layoutSubviews
{
    [self.configView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx == 0)
        {
            [obj.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = (UIButton *)obj;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }];
        }
    }];
}

@end
