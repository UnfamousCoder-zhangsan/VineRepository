//
//  UIView+LSCore.h
//  PublicLawyerChat
//
//  Created by JW on 2017/3/9.
//  Copyright © 2017年 就问律师. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (LSCore)

#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;


//设定消息圆角
- (void)addLeftMessageRoundedCorners;
- (void)addRightMessageRoundedCorners;


///设置渐变
-(void)gradientViewWithLeftColor:(UIColor *)leftColor rightColor:(UIColor *)rightColor;
-(void)gradientViewWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;
@end
