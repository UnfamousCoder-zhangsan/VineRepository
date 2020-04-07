//
//  UIView+LSCore.m
//  PublicLawyerChat
//
//  Created by JW on 2017/3/9.
//  Copyright © 2017年 就问律师. All rights reserved.
//

#import "UIView+LSCore.h"
@implementation UIView (LSCore)
#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}


- (void)addLeftMessageRoundedCorners{
    [self addRoundedCorners:UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight withRadii:CGSizeMake(15, 15)];
}
- (void)addRightMessageRoundedCorners{
    [self addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(15, 15)];
}


-(void)gradientViewWithLeftColor:(UIColor *)leftColor rightColor:(UIColor *)rightColor{
  //渐变设置
       
     
        NSArray *colors = [NSArray arrayWithObjects:(id)leftColor.CGColor, (id)rightColor.CGColor, nil];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        
        //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
        
        gradient.startPoint = CGPointMake(0, 0);
        
        gradient.endPoint = CGPointMake(1,0);
        
        gradient.colors = colors;
        
        gradient.frame = self.frame;
        
        [self.layer insertSublayer:gradient atIndex:0];
    
    
}
-(void)gradientViewWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor{
    NSArray *colors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
          
      CAGradientLayer *gradient = [CAGradientLayer layer];
      
      //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
      
      gradient.startPoint = CGPointMake(0, 0);
      
      gradient.endPoint = CGPointMake(0,1);
      
      gradient.colors = colors;
      
      gradient.frame = self.frame;
      
      [self.layer insertSublayer:gradient atIndex:0];
}
@end
