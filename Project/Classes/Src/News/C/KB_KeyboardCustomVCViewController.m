//
//  KB_KeyboardCustomVCViewController.m
//  Project
//
//  Created by hi  kobe on 2020/5/22.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_KeyboardCustomVCViewController.h"

static CGFloat const kToolbarHeight = 56;

@interface KB_KeyboardCustomVCViewController () <QMUIKeyboardManagerDelegate,QMUITextViewDelegate>


@end

@implementation KB_KeyboardCustomVCViewController


//设置导航栏背景色
- (UIImage *)navigationBarBackgroundImage{
   return [[UIImage alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorClear;
}

- (void)initSubviews {
    [super initSubviews];
    
    _maskControl = [[UIControl alloc] init];
    self.maskControl.backgroundColor = UIColorMask;
    [self.maskControl addTarget:self action:@selector(handleCancelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.maskControl];
    
    _containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = UIColorForBackground;
    self.containerView.layer.cornerRadius = 8;
    [self.view addSubview:self.containerView];
    
    _textView = [[QMUITextView alloc] init];
    self.textView.font = UIFontMake(16);
    self.textView.placeholder = @"发表你的想法...";
    self.textView.textContainerInset = UIEdgeInsetsMake(16, 12, 16, 12);
    self.textView.layer.cornerRadius = 8;
    self.textView.maximumTextLength = 50;
    self.textView.delegate = self;
    self.textView.clipsToBounds = YES;
    self.textView.backgroundColor = UIColor.qd_backgroundColorLighten;
    [self.containerView addSubview:self.textView];
    
    _toolbarView = [[UIView alloc] init];
    self.toolbarView.backgroundColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<QDThemeProtocol> * _Nullable theme) {
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            return UIColorForBackground;
        }
        return UIColorMake(246, 246, 246);
    }];
    self.toolbarView.qmui_borderColor = UIColorSeparator;
    self.toolbarView.qmui_borderPosition = QMUIViewBorderPositionTop;
    [self.containerView addSubview:self.toolbarView];
    
    _cancelButton = [[QMUIButton alloc] init];
    self.cancelButton.titleLabel.font = UIFontMake(16);
    [self.cancelButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(handleCancelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton sizeToFit];
    [self.toolbarView addSubview:self.cancelButton];
    
    _publishButton = [[QMUIButton alloc] init];
    self.publishButton.titleLabel.font = UIFontMake(16);
    [self.publishButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.publishButton addTarget:self action:@selector(handleSendButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.publishButton sizeToFit];
    [self.toolbarView addSubview:self.publishButton];
    
    _keyboardManager = [[QMUIKeyboardManager alloc] initWithDelegate:self];
    // 设置键盘只接受 self.textView 的通知事件，如果当前界面有其他 UIResponder 导致键盘产生通知事件，则不会被接受
    [self.keyboardManager addTargetResponder:self.textView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.maskControl.frame = self.view.bounds;
    
    self.containerView.qmui_frameApplyTransform = CGRectFlatMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 200);
    
    self.toolbarView.frame = CGRectFlatMake(0, CGRectGetHeight(self.containerView.bounds) - kToolbarHeight, CGRectGetWidth(self.containerView.bounds), kToolbarHeight);
    self.cancelButton.frame = CGRectFlatMake(20, CGFloatGetCenter(CGRectGetHeight(self.toolbarView.bounds), CGRectGetHeight(self.cancelButton.bounds)), CGRectGetWidth(self.cancelButton.bounds), CGRectGetHeight(self.cancelButton.bounds));
    self.publishButton.frame = CGRectFlatMake(CGRectGetWidth(self.toolbarView.bounds) - CGRectGetWidth(self.publishButton.bounds) - 20, CGFloatGetCenter(CGRectGetHeight(self.toolbarView.bounds), CGRectGetHeight(self.publishButton.bounds)), CGRectGetWidth(self.publishButton.bounds), CGRectGetHeight(self.publishButton.bounds));
    
    self.textView.frame = CGRectFlatMake(0, 0, CGRectGetWidth(self.containerView.bounds), CGRectGetHeight(self.containerView.bounds) - kToolbarHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)removeFromParentViewController {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [super removeFromParentViewController];
}

- (void)showInParentViewController:(UIViewController *)controller {
    
    if (IS_LANDSCAPE) {
        [QDUIHelper forceInterfaceOrientationPortrait];
    }
    
    // 这一句访问了self.view，触发viewDidLoad:
    self.view.frame = controller.view.bounds;
    
    // 需要先布局好
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    [self.view layoutIfNeeded];
    
    // 这一句触发viewWillAppear:
    [self beginAppearanceTransition:YES animated:YES];
    
    self.maskControl.alpha = 0;
    
    [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        self.maskControl.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self didMoveToParentViewController:self];
        // 这一句触发viewDidAppear:
        [self endAppearanceTransition];
    }];
    
    [self.textView becomeFirstResponder];
}

- (void)hide {
    [self willMoveToParentViewController:nil];
    // 这一句触发viewWillDisappear:
    [self beginAppearanceTransition:NO animated:YES];
    [UIView animateWithDuration:.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        self.maskControl.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        // 这一句触发viewDidDisappear:
        [self endAppearanceTransition];
        [self.view removeFromSuperview];
    }];
}

- (void)handleSendButtonEvent:(id)sender {
    if (self.sendTextBlock) {
        self.sendTextBlock(self.textView.text);
    }
    [self.textView resignFirstResponder];
}

- (void)handleCancelButtonEvent:(id)sender {
    [self.textView resignFirstResponder];
}

#pragma mark - <QMUIKeyboardManagerDelegate>

- (void)keyboardWillChangeFrameWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    __weak __typeof(self)weakSelf = self;
    [QMUIKeyboardManager handleKeyboardNotificationWithUserInfo:keyboardUserInfo showBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
            CGFloat distanceFromBottom = [QMUIKeyboardManager distanceFromMinYToBottomInView:weakSelf.view keyboardRect:keyboardUserInfo.endFrame];
            weakSelf.containerView.layer.transform = CATransform3DMakeTranslation(0, - distanceFromBottom - CGRectGetHeight(self.containerView.bounds), 0);
        } completion:NULL];
    } hideBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
        [weakSelf hide];
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
            weakSelf.containerView.layer.transform = CATransform3DIdentity;
        } completion:NULL];
    }];
}


- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最大不超过%@个字符",@(self.textView.maximumTextLength)]];
}
@end
