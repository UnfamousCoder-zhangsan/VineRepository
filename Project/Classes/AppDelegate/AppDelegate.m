//
//  AppDelegate.m
//  PublicLawyerChat
//
//  Created by   on 15/5/20.
//  Copyright (c) 2015   jackli. All rights reserved.
//
#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "GuideViewController.h"

#import <AlipaySDK/AlipaySDK.h>

//振动
#import <AudioToolbox/AudioToolbox.h>
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <UMShare/UMShare.h>
#import "QMUIConfigurationTemplateDark.h"

#import <Bugtags/Bugtags.h>

#import <BMKLocationkit/BMKLocationComponent.h>

@interface AppDelegate() <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    // 向苹果注册推送，获取deviceToken并上报
//    [self registerAPNS:application];
    
    // 初始化应用配置
    [self initAPPWithOptions:launchOptions];

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [UserCenter save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [kSharedApplication setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    [UserCenter checkAndSetCloudPushAccount];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        return [self handleWithUrl:url];
    }
    return result;
}

#pragma mark - 初始化应用配置
- (void)initAPPWithOptions:(NSDictionary *)launchOptions
{
    // 1. 先注册主题监听，在回调里将主题持久化存储，避免启动过程中主题发生变化时读取到错误的值
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeDidChangeNotification:) name:QMUIThemeDidChangeNotification object:nil];

    // 2. 然后设置主题的生成器
    QMUIThemeManagerCenter.defaultThemeManager.themeGenerator = ^__kindof NSObject *_Nonnull(NSString *_Nonnull identifier)
    {
        return QMUIConfigurationTemplate.new;
    };

    // 3. 再针对 iOS 13 开启自动响应系统的 Dark Mode 切换
    // 如果不需要这个功能，则不需要这一段代码
    if (@available(iOS 13.0, *)) {
        QMUIThemeManagerCenter.defaultThemeManager.identifierForTrait = ^__kindof NSObject<NSCopying> *_Nonnull(UITraitCollection *_Nonnull trait)
        {
            if (trait.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return QDThemeIdentifierDefault;
            }

            if ([QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier isEqual:QDThemeIdentifierDark]) {
                return QDThemeIdentifierDefault;
            }

            return QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier;
        };
        QMUIThemeManagerCenter.defaultThemeManager.respondsSystemStyleAutomatically = YES;
    }
    // QD自定义的全局样式渲染
    [QDCommonUI renderGlobalAppearances];

    [self initThirdSDKWithOptions:launchOptions];

    [self initSVProgressHUD];

    [self initWindow];
    
    

}

- (void)handleThemeDidChangeNotification:(NSNotification *)notification
{
    QMUIThemeManager *manager = notification.object;
    if (![manager.name isEqual:QMUIThemeManagerNameDefault])
        return;

    [[NSUserDefaults standardUserDefaults] setObject:manager.currentThemeIdentifier forKey:QDSelectedThemeIdentifier];

    [QDThemeManager.currentTheme applyConfigurationTemplate];

    // 主题发生变化，在这里更新全局 UI 控件的 appearance
    [QDCommonUI renderGlobalAppearances];

    // 更新表情 icon 的颜色
    [QDUIHelper updateEmotionImages];
}

#pragma mark - 设置SVP样式
- (void)initSVProgressHUD
{
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    // 背景图层的颜色
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    // 文字的颜色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];

    [SVProgressHUD setErrorImage:nil];
    [SVProgressHUD setCornerRadius:2];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:13]];
}

#pragma mark - 初始化启动窗口
- (UIWindow *)window
{
    return PageRout_Maneger.window;
}

- (void)initWindow
{
//    NSString *guideVersion = [kUserDefaults objectForKey:@"ifFirstOpen"];
//    if (guideVersion.length == 0 || [guideVersion compare:@"1.0"] == NSOrderedAscending) {
//        // 如果本次安装是特定版本显示引导页，并清空数据
//        [UserCenter clearUserCenter];
//        GuideViewController *vc = [[GuideViewController alloc] init];
//        self.window.rootViewController = vc;
//        [kUserDefaults setObject:App_Version forKey:@"ifFirstOpen"];
//    } else {
        if ([UserCenter checkIsLogin]) {
            PageRout_Maneger.window.rootViewController = [PageRoutManeger APPMainVC];
        } else {
            [UserCenter clearUserCenter];
            [PageRoutManeger gotoLoginVC];
        }
   // }
    // 开屏广告初始化
    
    [PageRout_Maneger.window makeKeyAndVisible];
}

#pragma mark - 初始化第三方SDK
- (void)initThirdSDKWithOptions:(NSDictionary *)launchOptions
{
    [self setupUM];

   // [self initBaiduMap];
//    [Push_Manager initObserve];

//    [CloudPushSDK sendNotificationAck:launchOptions];
   // [self initCloudPush];
}

#pragma mark - 友盟配置
- (void)setupUM
{
   [UMConfigure initWithAppkey:@"5e9b0800978eea083f0c79ec" channel:@"App Store"];
   [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WxAppKey appSecret:WxAppSecret redirectURL:nil];
}
#pragma mark - 初始化百度地图
- (void)initBaiduMap {
    // 要使用百度地图，请先启动BaiduMapManager
    // 初始化定位SDK
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:kBaiDuMapAK authDelegate:nil];
    self.mapManager = [[BMKMapManager alloc]init];
    
    // 如果要关注网络及授权验证事件，请设定 generalDelegate参数
    BOOL ret = [self.mapManager start:kBaiDuMapAK generalDelegate:nil];
    if (!ret) {
        LQLog(@"manager start failed!");
    }
    
}
#pragma mark - 移动推送配置
- (void)initCloudPush
{
    // SDK初始化
//    [CloudPushSDK asyncInit:@"27858745"
//                  appSecret:@"174d5d1bd4a0437033d4ea5d4cc97349"
//                   callback:^(CloudPushCallbackResult *res) {
//                       if (res.success) {
//                           LQLog(@"Push SDK init success.");
//                       } else {
//                           LQLog(@"Push SDK init failed, error: %@", res.error);
//                       }
//                   }];
    // 监听推送消息到来
    [self registerMessageReceive];
}

/// 注册苹果推送，获取deviceToken用于推送
/// @param application
- (void)registerAPNS:(UIApplication *)application
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:
                         [UIUserNotificationSettings settingsForTypes:
                                                         (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                           categories:nil]];
        [application registerForRemoteNotifications];
    }
}

/// 苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    [CloudPushSDK registerDevice:deviceToken
//                    withCallback:^(CloudPushCallbackResult *res) {
//                        if (res.success) {
//                            LQLog(@"Register deviceToken success.");
//                        } else {
//                            LQLog(@"Register deviceToken failed, error: %@", res.error);
//                        }
//                    }];
}

/// 苹果推送注册失败回调
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    LQLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

/// 注册推送消息到来监听
- (void)registerMessageReceive
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}

/// 处理到来推送消息
/// @param notification
- (void)onMessageReceived:(NSNotification *)notification
{
//    CCPSysMessage *message = [notification object];
//    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
//    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
//    LQLog(@"Receive message title: %@, content: %@.", title, body);
//    if (!title) {
//        title = @"";
//    }
//
//    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[body jsonValueDecoded]];
//    if (!jsonDict[@"title"]) {
//        jsonDict[@"title"] = title;
//    }
//
//    [[RACScheduler mainThreadScheduler] schedule:^{
//        [Push_Manager didReceiveRemoteMessages:jsonDict];
//    }];
}

#pragma mark - 当没有实现对应系统的方法时无论APP在前台或后台都会调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // iOS badge 清0
    application.applicationIconBadgeNumber = 0;
//    [CloudPushSDK sendNotificationAck:userInfo];
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        return;
    } else {
        [[RACScheduler mainThreadScheduler] schedule:^{
//            [Push_Manager didOpenRemoteNotification:userInfo];
        }];
    }
}

#pragma mark - iOS10及以上专用：触发通知动作时回调，比如点击、删除通知和点击自定义action(应用外点击推送)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    // 点击打开订单详情页
//    [Push_Manager didOpenRemoteNotification:userInfo];
}

#pragma mark - iOS10及以上专用:APP处于前台收到推送
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
//    [CloudPushSDK sendNotificationAck:userInfo];
    // 通知不弹出(iOS10下APP在前台也可设置通知弹出)
    completionHandler(UNNotificationPresentationOptionNone);
    [[RACScheduler mainThreadScheduler] schedule:^{
//        [Push_Manager didOpenRemoteNotification:userInfo];
    }];
}

#pragma mark - 处理支付宝微信回调
- (BOOL)handleWithUrl:(NSURL *)url
{
    // 其他如支付等SDK的回调
    if ([url.host isEqualToString:@"safepay"]) {
        // 设备已安装支付宝客户端情况下，处理支付宝客户端返回的url
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      LQLog(@"支付结果：%@", resultDic);
                                                  }];
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             LQLog(@"result = %@", resultDic);
                                             // 解析 auth code
                                             NSString *result = resultDic[@"result"];
                                             NSString *authCode = nil;
                                             if (result.length > 0) {
                                                 NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                                                 for (NSString *subResult in resultArr) {
                                                     if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                                                         authCode = [subResult substringFromIndex:10];
                                                         break;
                                                     }
                                                 }
                                             }
                                             LQLog(@"授权结果 authCode = %@", authCode ?: @"");
                                         }];
    }
    return YES;
}
@end
