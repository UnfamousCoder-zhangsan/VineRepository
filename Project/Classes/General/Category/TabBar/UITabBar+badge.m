//
//  UITabBar+badge.m
//  Project
//
//  Created by ChesterLee on 2019/9/28.
//  Copyright © 2019 64365. All rights reserved.
//

#import "UITabBar+badge.h"
#define TabbarItemNums 2.0    //tabbar的数量

@implementation UITabBar (badge)
- (void)showBadgeOnItemIndex:(int)index{

    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];

    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 4;
    badgeView.backgroundColor = APPColor_Red;
    CGRect tabFrame = self.frame;

    //确定小红点的位置
    float percentX = (index +0.55) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    badgeView.frame = CGRectMake(x, 5, 8, 8);
    [self addSubview:badgeView];

}

- (void)hideBadgeOnItemIndex:(int)index{

    //移除小红点
    [self removeBadgeOnItemIndex:index];

}

- (void)removeBadgeOnItemIndex:(int)index{

    //按照tag值进行移除
    for (UIView *subView in self.subviews) {

        if (subView.tag == 888+index) {

            [subView removeFromSuperview];

        }
    }
}
@end
