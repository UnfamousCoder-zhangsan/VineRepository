//
//  QDTabBarViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/6/2.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDTabBarViewController.h"

@interface QDTabBarViewController ()<UITabBarDelegate>

@end

@implementation QDTabBarViewController
/// 点击了第几个tabbar
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    LQLog(@"%@",item.title);
}
@end
