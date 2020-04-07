//
//  UIImage+Extension.h
//  LawChatForLawyer
//
//  Created by JW on 2017/7/15.
//  Copyright © 2017年 就问律师. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Extension)

/// 裁剪成圆形
- (UIImage *)circleImage;

/// 传入图片的名称,返回一张可拉伸不变形的图片
+ (UIImage *)lv_resizableImageWithImage:(UIImage *)image;


/**
 返回一张圆角UIImage
 */
+ (UIImage *)lv_circleImage:(UIImage *)image;

/**
 将图片旋转一定的角度
 */
- (UIImage *)lv_imageRotatedByDegrees:(CGFloat)degrees;


@end
