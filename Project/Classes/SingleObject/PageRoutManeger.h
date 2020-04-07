//
//  PageRoutManeger.h
//  Project
//
//  Created by Juice on 2018/3/21.
//  Copyright © 2018年 jacli. All rights reserved.
//

#import "QDTabBarViewController.h"
#import <Foundation/Foundation.h>
#import <AXWebViewController/AXWebViewController-umbrella.h>
#import "QDNavigationController.h"
#define PageRout_Maneger [PageRoutManeger sharedInstance]

/// 全局页面路由管理
@interface PageRoutManeger : NSObject

/// 根Window
@property (strong, nonatomic) UIWindow *window;

/// 记录APP当前浏览页面的NavigationController，用于随时push页面使用
@property (nonatomic, weak) UINavigationController *currentNaviVC;

/// 获得单例
+ (instancetype)sharedInstance;

/// 初始化主要得APP根视图控制器TabBarVC
+ (QDTabBarViewController *)APPMainVC;

+ (void)showShootVC;

/// 改变根界面（登录成功进入APP，强制登录型使用，可选登录型只需要登录成功后pop掉登录页面即可）
+ (void)changeWindowRootToMainVC;

/// 跳转到登录页面
+ (void)gotoLoginVC;

/// 退出登录返回主页面（退出登录跳转到登录页面）
+ (void)exitToLoginVC;

/// 通过Storyboard跳转vc
/// @param vcIdentifier controller在storyboard上的Identifier
/// @param storyboardName storyboard的名称
+ (void)pushToViewController:(NSString *)vcIdentifier inStoryboard:(NSString *)storyboardName;

/// Storyboard创建Controller对象
/// @param vcIdentifier controller在storyboard上的Identifier
/// @param storyboardName storyboard的名称
+ (UIViewController *)initWithVCIdentifier:(NSString *)vcIdentifier inStoryboard:(NSString *)storyboardName;


/// 跳转网页浏览器界面
/// @param url 网页地址String
+ (AXWebViewController *)gotoWebWithUrl:(NSString *)url;

/// 跳转网页浏览器界面
/// @param url 网页地址String
/// @param title 页面导航栏标题
+ (AXWebViewController *)gotoWebWithUrl:(NSString *)url title:(NSString *)title;

@end
