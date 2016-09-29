//
//  UIImage+blurryImage.h
//  PhotoShare
//
//  Created by kongfanyi on 16/9/21.
//  Copyright © 2016年 dd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (blurryImage)

+(UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

+(UIImage *)snapshot:(UIView *)view;

+(CGRect)getFrameSizeForImage:(UIImage *)image inImageView:(UIImageView *)imageView;

//获得某个范围内的屏幕图像
+(UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r;

//ios合并两张图片(叠加两张图片 重合两张图片)
+(UIImage *)addImage:(UIImage *)image1 withImage:(UIImage *)image2;

//按比例缩放
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

//自定长宽
+(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

-(UIImage *)imageCompressForWidth:(CGFloat)defineWidth;

//从UIImageView中获得Image位置的函数
-(CGRect)getFrameinImageView:(UIImageView *)imageView;

@end
