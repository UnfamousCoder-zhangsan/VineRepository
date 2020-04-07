//
//  AlertHelper.m
//  Project
//
//  Created by ChesterLee on 2019/11/15.
//  Copyright © 2019 64365. All rights reserved.
//

#import "AlertHelper.h"

@implementation AlertHelper
#pragma mark - 显示警示框（无标题，一个按钮）
+ (QMUIAlertController *)showAlertMessage:(NSString *)message okBlock:(void (^)(void))okBlock
{
    return [self showAlertMessage:message okText:@"我知道了" okBlock:okBlock];
}

#pragma mark - 显示警示框（无标题，一个按钮）
+ (QMUIAlertController *)showAlertMessage:(NSString *)message okText:(NSString *)okText okBlock:(void (^)(void))okBlock
{
    QMUIAlertController *alertController = [self mainAlertInitWithTitle:nil message:message];

    // 底部按钮
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:okText
                                                          style:QMUIAlertActionStyleCancel
                                                        handler:^(__kindof QMUIAlertController *_Nonnull aAlertController, QMUIAlertAction *_Nonnull action) {
                                                            okBlock ? okBlock() : nil;
                                                        }];
    [alertController addAction:action1];
    [alertController showWithAnimated:YES];

    return alertController;
}

#pragma mark - 显示警示框（有标题，一个按钮）
+ (QMUIAlertController *)showAlertTitle:(NSString *)title message:(NSString *)message okBlock:(void (^)(void))okBlock
{
    return [self showAlertTitle:title message:message okText:@"我知道了" okBlock:okBlock];
}

#pragma mark - 显示警示框（有标题，一个按钮）
+ (QMUIAlertController *)showAlertTitle:(NSString *)title message:(NSString *)message okText:(NSString *)okText okBlock:(void (^)(void))okBlock
{
    // 弹窗

    QMUIAlertController *alertController = [self mainAlertInitWithTitle:title message:message];

    // 底部按钮
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:okText
                                                          style:QMUIAlertActionStyleDefault
                                                        handler:^(__kindof QMUIAlertController *_Nonnull aAlertController, QMUIAlertAction *_Nonnull action) {
                                                            okBlock ? okBlock() : nil;
                                                        }];
    [alertController addAction:action1];
    [alertController showWithAnimated:YES];

    return alertController;
}

#pragma mark - 显示警示框（有标题，两个按钮）
+ (QMUIAlertController *)showAlertTitle:(NSString *)title message:(NSString *)message cancelBlock:(void (^)(void))cancelBlock okBlock:(void (^)(void))okBlock
{
    return [self showAlertTitle:title message:message cancelText:@"取消" okText:@"确定" okImage:nil cancelBlock:cancelBlock okBlock:okBlock];
}

#pragma mark - 显示警示框（有标题，两个按钮）
+ (QMUIAlertController *)showAlertTitle:(NSString *)title message:(NSString *)message cancelText:(NSString *)cancelText okText:(NSString *)okText cancelBlock:(void (^)(void))cancelBlock okBlock:(void (^)(void))okBlock
{
    return [self showAlertTitle:title message:message cancelText:cancelText okText:okText okImage:nil cancelBlock:cancelBlock okBlock:okBlock];
}

#pragma mark - 显示警示框（有标题，两个按钮）
+ (QMUIAlertController *)showAlertTitle:(NSString *)title message:(NSString *)message cancelText:(NSString *)cancelText okText:(NSString *)okText okImage:(UIImage *)okImage cancelBlock:(void (^)(void))cancelBlock okBlock:(void (^)(void))okBlock
{
    // 弹窗
    QMUIAlertController *alertController = [self mainAlertInitWithTitle:title message:message];


    // 底部按钮
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:cancelText
                                                          style:QMUIAlertActionStyleCancel
                                                        handler:^(__kindof QMUIAlertController *_Nonnull aAlertController, QMUIAlertAction *_Nonnull action) {
                                                            cancelBlock ? cancelBlock() : nil;
                                                        }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:okText
                                                          style:QMUIAlertActionStyleDefault
                                                        handler:^(__kindof QMUIAlertController *_Nonnull aAlertController, QMUIAlertAction *_Nonnull action) {
                                                            okBlock ? okBlock() : nil;
                                                        }];
    if (okImage) {
        [action2.button setImage:okImage forState:UIControlStateNormal];
        action2.button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    }
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];

    return alertController;
}

+ (QMUIAlertController *)mainAlertInitWithTitle:(NSString *)title message:(NSString *)message
{
    // 弹窗
    QMUIAlertController *alertController = [[QMUIAlertController alloc] initWithTitle:title message:message preferredStyle:QMUIAlertControllerStyleAlert];
    alertController.alertContentMaximumWidth = 285;
    alertController.alertButtonBackgroundColor = UIColorWhite;
    alertController.alertContentCornerRadius = 5;
    alertController.alertButtonHeight = 50;
    alertController.alertHeaderInsets = UIEdgeInsetsMake(20, 25, 20, 25);
    alertController.alertTitleMessageSpacing = 13;
    alertController.alertHeaderBackgroundColor = UIColorWhite;
    alertController.alertSeparatorColor = APPColor_DDD;

    NSMutableDictionary *titleAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertTitleAttributes];
    titleAttributs[NSForegroundColorAttributeName] = UIColorMakeWithHex(@"222222");
    titleAttributs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    alertController.alertTitleAttributes = titleAttributs;

    NSMutableDictionary *messageAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertMessageAttributes];
    messageAttributs[NSForegroundColorAttributeName] = UIColorMakeWithHex(@"888888");
    messageAttributs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.minimumLineHeight = 22;
    ps.lineSpacing = 8;
    ps.maximumLineHeight = 15;
    ps.alignment = NSTextAlignmentCenter;
    messageAttributs[NSParagraphStyleAttributeName] = ps;
    alertController.alertMessageAttributes = messageAttributs;

    NSMutableDictionary *buttonAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertButtonAttributes];
    buttonAttributes[NSForegroundColorAttributeName] = APPColor_Blue;
    alertController.alertButtonAttributes = buttonAttributes;

    NSMutableDictionary *cancelButtonAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertCancelButtonAttributes];
    cancelButtonAttributes[NSForegroundColorAttributeName] = UIColorMakeWithHex(@"#555555");
    alertController.alertCancelButtonAttributes = cancelButtonAttributes;

    return alertController;
}

@end
