//
//  KB_KeyboardCustomVCViewController.h
//  Project
//
//  Created by hi  kobe on 2020/5/22.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SendTextBlock)(NSString *text);

@interface KB_KeyboardCustomVCViewController : QDCommonViewController 
@property(nonatomic, strong) QMUIKeyboardManager *keyboardManager;

@property(nonatomic, strong) UIControl *maskControl;
@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) QMUITextView *textView;

@property(nonatomic, strong) UIView *toolbarView;
@property(nonatomic, strong) QMUIButton *cancelButton;
@property(nonatomic, strong) QMUIButton *publishButton;

@property(nonatomic, copy) SendTextBlock sendTextBlock;

- (void)showInParentViewController:(UIViewController *)controller;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
