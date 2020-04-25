//
//  KB_ScrollPageViewController.m
//  Project
//
//  Created by hi  kobe on 2020/4/24.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_ScrollPageViewController.h"
#import "UIViewController+ZJScrollPageController.h"
//#import "ZJScrollPageView/ZJScrollPageView.h"

@interface KB_ScrollPageViewController ()

@end

@implementation KB_ScrollPageViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.index == 0) {
        LQLog(@"初始化了第一个控制器");
    } else {
        LQLog(@"初始化了第二个控制器");
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.index == 0) {
        LQLog(@"初始化了第一个控制器");
    } else {
        LQLog(@"初始化了第二个控制器");
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (void)zj_viewDidLoadForIndex:(NSInteger)index{

}

@end
