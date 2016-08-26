//
//  ExtendEditMultipleView.m
//  PhotoShare
//
//  Created by kongfanyi on 16/8/22.
//  Copyright © 2016年 dd. All rights reserved.
//

#import "ExtendEditMultipleView.h"
#import "UIView+Extension.h"

@implementation ExtendEditMultipleView

-(void)layoutSubviews
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx == 3)
        {
            obj.height = self.height - 80;
            *stop = YES;
        }
    }];
}

@end
