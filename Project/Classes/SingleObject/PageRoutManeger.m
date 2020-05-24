//
//  PageRoutManeger.m
//  Project
//
//  Created by Juice on 2018/3/21.
//  Copyright © 2018年 jacli. All rights reserved.
//

#import "PageRoutManeger.h"
#import "LoginVC.h"
#import "KB_MineTVC.h"
#import "KB_ShootVC.h"
#import "KB_MessageTVC.h"
#import "KB_NewsTVC.h"
#import "KB_HomePageViewController.h"

static PageRoutManeger *_sharedPageRoutManeger;

@implementation PageRoutManeger
#pragma mark - 获得单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t token;

    dispatch_once(&token, ^{
        if (!_sharedPageRoutManeger) {
            _sharedPageRoutManeger = [[PageRoutManeger alloc] init];
        }
    });
    return _sharedPageRoutManeger;
}

- (UIWindow *)window
{
    if (!_window) {
        // 创建window
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.backgroundColor = APPColor_BackgroudView;
    }
    return _window;
}

#pragma mark - 初始化主要得APP根视图控制器TabBarVC
+ (QDTabBarViewController *)APPMainVC
{
    QDTabBarViewController *tabBarViewController = [[QDTabBarViewController alloc] init];
    
    
    KB_HomePageViewController *videoTVC = [[KB_HomePageViewController alloc] init];
    videoTVC.hidesBottomBarWhenPushed = NO;
    QDNavigationController *videoNavController = [[QDNavigationController alloc] initWithRootViewController:videoTVC];
    videoNavController.tabBarItem = [QDUIHelper tabBarItemWithTitle:@"首页" image:[UIImageMake(@"tabbar_indicater_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageMake(@"tabbar_indicater_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    videoNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(20, 0, -20, 0);
    videoNavController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -20);
    
    KB_NewsTVC *newsTVC = [[KB_NewsTVC alloc] init];
    newsTVC.hidesBottomBarWhenPushed = NO;
    QDNavigationController *newsNavController = [[QDNavigationController alloc] initWithRootViewController:newsTVC];
    newsNavController.tabBarItem = [QDUIHelper tabBarItemWithTitle:@"美食" image:[UIImageMake(@"tabbar_indicater_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageMake(@"tabbar_indicater_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:1];
    newsNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(20, 0, -20, 0);
    newsNavController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -20);
    
    UIViewController *tempVC = [[UIViewController alloc] init];
    QDNavigationController *tempNaviVC = [[QDNavigationController alloc] initWithRootViewController:tempVC];
    tempNaviVC.tabBarItem = [QDUIHelper tabBarItemWithTitle:nil image:nil selectedImage:nil tag:2];
    
    KB_MessageTVC *messageTVC = [[KB_MessageTVC alloc] init];
    messageTVC.hidesBottomBarWhenPushed = NO;
    QDNavigationController *messageNavController = [[QDNavigationController alloc] initWithRootViewController:messageTVC];
    messageNavController.tabBarItem = [QDUIHelper tabBarItemWithTitle:@"消息" image:[UIImageMake(@"tabbar_indicater_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageMake(@"tabbar_indicater_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:3];
    messageNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(20, 0, -20, 0);
    messageNavController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -20);
    
    KB_MineTVC *mineTVC = [[KB_MineTVC alloc] init];
    mineTVC.hidesBottomBarWhenPushed = NO;
    QDNavigationController *mineNavController = [[QDNavigationController alloc] initWithRootViewController:mineTVC];
    mineNavController.tabBarItem = [QDUIHelper tabBarItemWithTitle:@"我的" image:[UIImageMake(@"tabbar_indicater_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageMake(@"tabbar_indicater_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:4];
    mineNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(20, 0, -20, 0);
    mineNavController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -20);
    
    tabBarViewController.viewControllers = @[videoNavController, newsNavController, tempNaviVC, messageNavController, mineNavController];
    
    
    QMUIButton *shootBtn = [[QMUIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 5 * 2, 0, SCREEN_WIDTH / 5, 49)];
    [shootBtn setImage:UIImageMake(@"tabbar_shoot") forState:UIControlStateNormal];
    [[shootBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [PageRoutManeger showShootVC];
    }];
    [tabBarViewController.tabBar addSubview:shootBtn];
    return tabBarViewController;
}

+ (void)showShootVC{
    KB_ShootVC *shootVC = [[UIStoryboard storyboardWithName:@"Shoot" bundle:nil] instantiateViewControllerWithIdentifier:@"KB_ShootVC"];
     QDNavigationController *naviController = [[QDNavigationController alloc] initWithRootViewController:shootVC];
    naviController.modalPresentationStyle = UIModalPresentationFullScreen;
    [PageRout_Maneger.currentNaviVC presentViewController:naviController animated:YES completion:^{
    }];
}

#pragma mark - 改变根界面（登录成功进入APP，强制登录型使用，可选登录型只需要登录成功后pop掉登录页面即可）
+ (void)changeWindowRootToMainVC
{
    [UIView transitionWithView:PageRout_Maneger.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [PageRout_Maneger.window setRootViewController:[self APPMainVC]];
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:NULL];
}

#pragma mark - 跳转到登录页面
+ (void)gotoLoginVC
{
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginVC *loginVC = [SB instantiateViewControllerWithIdentifier:@"LoginVC"];

    // 强制登录型切换根视图
    [UIView transitionWithView:PageRout_Maneger.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [PageRout_Maneger.window setRootViewController:[[QDNavigationController alloc] initWithRootViewController:loginVC]];
                        PageRout_Maneger.currentNaviVC = loginVC.navigationController;
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:NULL];
}

#pragma mark - 退出登录返回主页面（退出登录跳转到登录页面）
+ (void)exitToLoginVC
{
    // 移除其他弹窗window
    [[UIApplication sharedApplication].windows enumerateObjectsUsingBlock:^(__kindof UIWindow *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (idx != 0) {
            obj.hidden = YES;
        }
    }];
    [UserCenter clearUserCenter];

    [self gotoLoginVC];
}

#pragma mark - 检测是否已经打开某个页面
+ (UIViewController *)containtController:(NSString *)className
{
    for (UIViewController *vc in PageRout_Maneger.currentNaviVC.viewControllers) {
        if ([vc.className isEqualToString:className]) {
            return vc;
        }
    }
    return nil;
}

+ (void)pushToViewController:(NSString *)vcIdentifier inStoryboard:(NSString *)storyboardName
{
    UIStoryboard *SB = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *VC = [SB instantiateViewControllerWithIdentifier:vcIdentifier];
    [PageRout_Maneger.currentNaviVC pushViewController:VC animated:YES];
}

+ (UIViewController *)initWithVCIdentifier:(NSString *)vcIdentifier inStoryboard:(NSString *)storyboardName
{
    UIStoryboard *SB = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    return [SB instantiateViewControllerWithIdentifier:vcIdentifier];
}


#pragma mark - push网页
+ (AXWebViewController *)gotoWebWithUrl:(NSString *)url
{
    AXWebViewController *webVC = [[AXWebViewController alloc] initWithAddress:url];
    webVC.showsToolBar = NO;
    if (AX_WEB_VIEW_CONTROLLER_iOS9_0_AVAILABLE()) {
        webVC.webView.allowsLinkPreview = YES;
    }
    [PageRout_Maneger.currentNaviVC pushViewController:webVC animated:YES];
    return webVC;
}

+ (AXWebViewController *)gotoWebWithUrl:(NSString *)url title:(NSString *)title
{
    AXWebViewController *webVC = [[AXWebViewController alloc] initWithAddress:url];
    webVC.title = title;
    webVC.showsToolBar = NO;
    if (AX_WEB_VIEW_CONTROLLER_iOS9_0_AVAILABLE()) {
        webVC.webView.allowsLinkPreview = YES;
    }
    [PageRout_Maneger.currentNaviVC pushViewController:webVC animated:YES];
    return webVC;
}
@end
