//
//  UIImage+ImageNotCached.m
//  Etion
//
//  Created by cracker on 15/8/29.
//  Copyright (c) 2015年 GuangZhouXuanWu. All rights reserved.
//

#import "UIImage+ImageNotCached.h"

@implementation UIImage (ImageNotCached)

+(UIImage *)ImageNotCached:(NSString *)filename
{
    NSString *imageFile = [[NSString alloc] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageFile];
    return image;
}

@end
