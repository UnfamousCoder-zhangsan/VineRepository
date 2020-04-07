//
//  QDNavigationController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/4/13.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDNavigationController.h"

@interface QDNavigationController ()

@end

@implementation QDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self configShadow];
}
-(void)configShadow{
    self.navigationBar.clipsToBounds = NO;
    self.navigationBar.qmui_backgroundView.layer.shadowColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    self.navigationBar.qmui_backgroundView.layer.shadowOffset = CGSizeMake(0,1);
    self.navigationBar.qmui_backgroundView.layer.shadowOpacity = 1;
    self.navigationBar.qmui_backgroundView.layer.shadowRadius = 3;
}

@end
