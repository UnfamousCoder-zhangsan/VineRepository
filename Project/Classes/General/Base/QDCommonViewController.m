//
//  QDCommonViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/4/13.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDCommonViewController.h"

@implementation QDCommonViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    if (IsUITest) {
        self.view.accessibilityLabel = [NSString stringWithFormat:@"viewController-%@", self.title];
    }
    
    self.view.backgroundColor = APPColor_BackgroudView;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)showEmptyView {
    [super showEmptyView];
    ((UIActivityIndicatorView*)self.emptyView.loadingView).color = UIColorWhite;
    self.emptyView.backgroundColor = APPColor_BackgroudView;
    self.emptyView.detailTextLabel.font = [UIFont systemFontOfSize:15];
    self.emptyView.detailTextLabel.textColor = UIColorMakeWithHex(@"#222222");
    self.emptyView.textLabel.textColor = UIColorMakeWithHex(@"#222222");
    self.emptyView.textLabel.font = [UIFont systemFontOfSize:15];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    if (IsUITest && self.isViewLoaded) {
        self.view.accessibilityLabel = [NSString stringWithFormat:@"viewController-%@", self.title];
    }
}

- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    return YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
            return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDarkContent;
    }
    return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}
-(void)showNoDataEmptyViewWithText:(NSString *_Nullable)text detailText:(NSString *_Nullable)detailText {
    [self showEmptyViewWithImage:[UIImage imageNamed:@"nodata"] text:text detailText:detailText buttonTitle:nil buttonAction:nil];
}

-(void)showErrorEmptyViewWithText:(NSString * _Nullable)text acion:(SEL _Nullable)action {
    [self showEmptyViewWithImage:[UIImage imageNamed:@"404"] text:text.length ?text : @"网络异常" detailText:nil buttonTitle:@"点击重试" buttonAction:action];
}
-(CGFloat)navigationBarHeight{
    return CGRectGetHeight(self.navigationController.navigationBar.bounds);
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//一开始的方向
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
@end
