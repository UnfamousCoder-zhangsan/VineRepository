//
//  UITableViewCell+sectionCell.m
//  Project
//
//  Created by xiexi on 2020/1/20.
//  Copyright © 2020 674297026@qq.com. All rights reserved.
//

#import "UITableViewCell+sectionCell.h"




@implementation UITableViewCell (sectionCell)
//绘制背景 有圆角 阴影
-(void)backgroundViewWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cornerRadius:(CGFloat)cornerRadius bounds:(CGRect)bounds needSeparate:(BOOL)needSeparate {
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
  
    NSInteger rows = [tableView numberOfRowsInSection:indexPath.section];
 
    BOOL separator = NO;
    if (indexPath.row == 0 && rows == 1) {
        CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
         separator = NO;
    }else if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        
        //第一行
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        separator = YES;
        
    } else if (indexPath.row == rows -1) {
        // 初始起点为cell的左上角坐标
        //最后一行
        //最后一行不添加分割线
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        separator = NO;
    } else {
        CGPathAddRect(pathRef, nil, bounds);
        separator = YES;
    }
    
    layer.path = pathRef;
    backgroundLayer.path = pathRef;
    CFRelease(pathRef);
    //背景色
    
    layer.fillColor =   [UIColor colorWithHexString:@"#374170"].CGColor;
    
    
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    [roundView.layer insertSublayer:layer atIndex:0];
    self.backgroundView = roundView;
     
    //添加分割线
    if(separator == YES && needSeparate == YES){
        CALayer *lineLayer = [[CALayer alloc] init];
        CGFloat lineHeight = 0.5;
        CGFloat lineX = CGRectGetMinX(bounds) + 15;
        lineLayer.frame = CGRectMake(lineX, bounds.size.height - lineHeight, CGRectGetWidth(bounds) - (lineX + CGRectGetMinX(bounds)), lineHeight);

        lineLayer.backgroundColor = [UIColor colorWithHexString:@"#424F71"].CGColor;
        [self.layer insertSublayer:lineLayer above:layer];
    
    }
   
    
   
    //点击效果背景色
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
    backgroundLayer.fillColor = [UIColor clearColor].CGColor;
    [selectedBackgroundView.layer insertSublayer:backgroundLayer below:self.layer];
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    self.selectedBackgroundView = selectedBackgroundView;
   
}
@end
