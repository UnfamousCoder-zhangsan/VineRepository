//
//  GuideViewController.m
//  LawChatForLawyer
//
//  Created by 李庆 on 15/5/15.
//  Copyright (c) 2015年 李庆. All rights reserved.
//

#import "GuideViewController.h"
#import <PageControls/PageControls-Swift.h>

@interface GuideViewController() <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *aSscroll;

@property (nonatomic, strong) QMUIGhostButton *loginBtn;

@property (nonatomic, strong) SnakePageControl *pageControl;

@property (nonatomic, strong) NSMutableArray<UIView *> *pageViews;

@end

@implementation GuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];


    [self.view addSubview:self.aSscroll];

    for (UIView *view in self.pageViews) {
        [self.aSscroll addSubview:view];
    }
    [self.aSscroll addSubview:self.loginBtn];
    // page
    [self.view addSubview:self.pageControl];
}

- (UIScrollView *)aSscroll
{
    if (!_aSscroll) {
        _aSscroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _aSscroll.delegate = self;
        _aSscroll.bounces = NO;
        _aSscroll.pagingEnabled = YES;
        _aSscroll.contentSize = CGSizeMake(SCREEN_WIDTH * self.pageViews.count, SCREEN_HEIGHT);
        _aSscroll.showsVerticalScrollIndicator = NO;
        _aSscroll.showsHorizontalScrollIndicator = NO;
    }
    return _aSscroll;
}

- (NSMutableArray<UIView *> *)pageViews
{
    if (!_pageViews) {
        _pageViews = [NSMutableArray array];
        // 前3页
        for (NSInteger i = 0; i < 3; i++) {
//            GuidePageView *view = [[NSBundle mainBundle] loadNibNamed:@"GuidePageView" owner:self options:nil].firstObject;
//            view.frame = CGRectMakeWithSize(CGSizeMake(313, 527));
//            view.center = self.view.center;
//            view.frame = CGRectSetX(view.frame, view.qmui_left + SCREEN_WIDTH * i);
//            view.page = i;
//            [_pageViews addObject:view];
        }
    }
    return _pageViews;
}

- (QMUIGhostButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [[QMUIGhostButton alloc] init];
        _loginBtn.ghostColor = APPColor_333;
        [_loginBtn setTitle:@"去登录" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:19];
        _loginBtn.layer.borderWidth = 2;
        _loginBtn.frame = CGRectMake(0, 0, 120, 45);
        _loginBtn.centerX = SCREEN_WIDTH * (self.pageViews.count - 0.5);
        _loginBtn.centerY = SCREEN_HEIGHT * 0.87;
        @weakify(self)
        [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl *_Nullable x) {
            @strongify(self)
            [self loginAction];
        }];
    }
    return _loginBtn;
}

- (SnakePageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[SnakePageControl alloc] initWithFrame:CGRectMake(0, 0, 60, 6)];
        _pageControl.center = CGPointMake(SCREEN_WIDTH / 2, self.loginBtn.centerY);
        _pageControl.activeTint = UIColorMakeWithHex(@"#000000");
        _pageControl.inactiveTint = UIColorMakeWithHex(@"#dddddd");
        _pageControl.pageCount = self.pageViews.count;
    }
    return _pageControl;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat t = scrollView.contentOffset.x;
    if (t < 0) {
        scrollView.contentOffset = CGPointZero;
    }
    if (t >= (self.pageViews.count - 1) * SCREEN_WIDTH) {
        scrollView.contentOffset = CGPointMake((self.pageViews.count - 1) * SCREEN_WIDTH, 0);
    }
    CGFloat page = scrollView.contentOffset.x / scrollView.frame.size.width;
    CGFloat progressInPage = scrollView.contentOffset.x - (page * scrollView.bounds.size.width);
    CGFloat progress = page + progressInPage;
    self.pageControl.progress = progress;

    // 设置最后一页渐变隐藏 pageControl
    self.pageControl.alpha = (SCREEN_WIDTH * (self.pageViews.count - 1) - t) / SCREEN_WIDTH;
}

- (void)loginAction
{
    [kUserDefaults setObject:App_Version forKey:@"ifFirstOpen"];

    self.view.userInteractionEnabled = NO;

    self.aSscroll.scrollEnabled = NO;

    // 跳转到登录页
    [PageRoutManeger gotoLoginVC];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
