//
//  AlertHelper.h
//  Project
//
//  Created by ChesterLee on 2019/11/15.
//  Copyright © 2019 64365. All rights reserved.
//

#import <Foundation/Foundation.h>

/// APP默认Alert样式
@interface AlertHelper : NSObject

/// 显示警示框（无标题，一个按钮）
/// @param message 消息内容
/// @param okBlock 点击“我知道了”回调
+ (QMUIAlertController *)showAlertMessage:(NSString *)message okBlock:(void (^)(void))okBlock;

/// 显示警示框（无标题，一个按钮）
/// @param message 消息内容
/// @param okText  确认按钮文案
/// @param okBlock 点击确认回调
+ (QMUIAlertController *)showAlertMessage:(NSString *)message okText:(NSString *)okText okBlock:(void (^)(void))okBlock;

/// 显示警示框（有标题，一个按钮）
/// @param title 标题
/// @param message 消息内容
/// @param okBlock 点击"我知道了"回调
+ (QMUIAlertController *)showAlertTitle:(NSString *)title message:(NSString *)message okBlock:(void (^)(void))okBlock;

/// 显示警示框（有标题，一个按钮）
/// @param title 标题
/// @param message 消息内容
/// @param okText 确认按钮文案
/// @param okBlock 确认按钮点击回调
+ (QMUIAlertController *)showAlertTitle:(NSString *)title message:(NSString *)message okText:(NSString *)okText okBlock:(void (^)(void))okBlock;

/// 显示警示框（有标题，两个按钮）
/// @param title 标题
/// @param message 消息内容
/// @param cancelBlock 取消按钮点击回调
/// @param okBlock 确认按钮点击回调
+ (QMUIAlertController *)showAlertTitle:(NSString *)title message:(NSString *)message cancelBlock:(void (^)(void))cancelBlock okBlock:(void (^)(void))okBlock;

/// 显示警示框（有标题，两个按钮）
/// @param title 标题
/// @param message 消息内容
/// @param cancelText 取消按钮文案
/// @param okText 确认按钮文案
/// @param cancelBlock 取消按钮点击回调
/// @param okBlock 确认按钮点击回调
+ (QMUIAlertController *)showAlertTitle:(NSString *)title message:(NSString *)message cancelText:(NSString *)cancelText okText:(NSString *)okText cancelBlock:(void (^)(void))cancelBlock okBlock:(void (^)(void))okBlock;

/// 显示警示框（有标题，两个按钮）
/// @param title 标题
/// @param message 消息内容
/// @param cancelText 取消按钮文案
/// @param okText 确认按钮文案
/// @param okImage 确认按钮图标
/// @param cancelBlock 取消按钮点击回调
/// @param okBlock 确认按钮点击回调
+ (QMUIAlertController *)showAlertTitle:(NSString *)title message:(NSString *)message cancelText:(NSString *)cancelText okText:(NSString *)okText okImage:(UIImage *)okImage cancelBlock:(void (^)(void))cancelBlock okBlock:(void (^)(void))okBlock;
@end
