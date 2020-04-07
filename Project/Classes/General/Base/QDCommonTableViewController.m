//
//  QDCommonTableViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/4/13.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDCommonTableViewController.h"

@implementation QDCommonTableViewController

- (void)initTableView
{
    [super initTableView];
   
    if (IsUITest) {
        self.tableView.accessibilityLabel = [NSString stringWithFormat:@"viewController-%@", self.title];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APPColor_BackgroudView;
    self.tableView.backgroundColor = APPColor_BackgroudView;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)showEmptyView
{
    [super showEmptyView];
    ((UIActivityIndicatorView*)self.emptyView.loadingView).color = UIColorWhite;
    self.emptyView.backgroundColor = self.tableView.backgroundColor;
    self.emptyView.detailTextLabel.font = [UIFont systemFontOfSize:15];
    self.emptyView.detailTextLabel.textColor = UIColorMakeWithHex(@"#888888");
    self.emptyView.textLabel.textColor = UIColorMakeWithHex(@"#888888");
    self.emptyView.textLabel.font = [UIFont systemFontOfSize:15];
}


- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    if (IsUITest && self.isViewLoaded) {
        self.tableView.accessibilityLabel = [NSString stringWithFormat:@"viewController-%@", self.title];
    }
}

- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable
{
    return YES;
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (@available(iOS 13.0, *)) {
        return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDarkContent;
    }
    return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

#pragma mark - <QDChangingThemeDelegate>
- (void)qmui_themeDidChangeByManager:(QMUIThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme
{
    [super qmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    [self.tableView reloadData];
}

#pragma mark - 添加下拉刷新
- (void)addPullRefreshWithBlock:(void (^)(void))block
{
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.tableView.mj_footer.hidden = NO;
        if (block) {
            block();
        }
    }];
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = 10;
    ((MJRefreshNormalHeader *)self.tableView.mj_header).lastUpdatedTimeLabel.hidden = YES;
    ((MJRefreshNormalHeader *)self.tableView.mj_header).loadingView.color = UIColorWhite;
    UIImage *image = ((MJRefreshNormalHeader *)self.tableView.mj_header).arrowView.image;
    ((MJRefreshNormalHeader *)self.tableView.mj_header).arrowView.image = [image qmui_imageWithTintColor:UIColorWhite];
    ((MJRefreshNormalHeader *)self.tableView.mj_header).stateLabel.hidden = YES;
}

#pragma mark - 上拉加载更多
- (void)addLoadingMoreWithBlock:(void (^)(void))block
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
    self.tableView.mj_footer = footer;
    
    footer.stateLabel.hidden = YES;//隐藏刷新时显示文字
    footer.loadingView.color = UIColorWhite;
    ((MJRefreshAutoNormalFooter*)footer).stateLabel.textColor = UIColorWhite;
}

- (void)endRefreshWithFooterHidden
{
    [self.tableView.mj_footer endRefreshing];
    // 通知已经全部加载完毕
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    self.tableView.mj_footer.hidden = YES;

}

- (void)showNoDataEmptyViewWithText:(NSString *_Nullable)text detailText:(NSString *_Nullable)detailText
{
    UIView *view = [self.emptyView viewWithTag:1001];
    if (view) {
        [view removeFromSuperview];
    }
    [self showEmptyViewWithImage:[UIImage imageNamed:@"nodata"] text:text detailText:detailText buttonTitle:nil buttonAction:nil];
}

- (void)showNoDataEmptyViewWithText:(NSString *_Nullable)text detailText:(NSString *_Nullable)detailText buttonTitle:(NSString *)buttonTitle
                       buttonAction:(SEL)action
{
    UIView *view = [self.emptyView viewWithTag:1001];
    if (view) {
        [view removeFromSuperview];
    }
    [self showEmptyViewWithImage:[UIImage imageNamed:@"nodata"]
                            text:text
                      detailText:detailText
                     buttonTitle:buttonTitle
                    buttonAction:action];
}


- (void)showErrorEmptyViewWithText:(NSString *_Nullable)text acion:(SEL _Nullable)action
{
    UIView *view = [self.emptyView viewWithTag:1001];
    if (view) {
        [view removeFromSuperview];
    }
    [self showEmptyViewWithImage:[UIImage imageNamed:@"404"] text:text.length ? text : @"网络异常" detailText:nil buttonTitle:@"点击重试" buttonAction:action];
}

- (void)showNoDataEmptyViewWithText:(NSString *_Nullable)text detailText:(NSString *_Nullable)detailText bottomLabelAttr:(NSMutableAttributedString *)bottomLabelAttr
{
    [self showNoDataEmptyViewWithText:text detailText:detailText];
    // 未开启接单
    // 相对于centerY的偏移量
    self.emptyView.verticalOffset = -(CGRectGetHeight(self.emptyView.bounds) / 2 - 127) / 2;
    YYLabel *label = [[YYLabel alloc] init];

    label.attributedText = bottomLabelAttr;


    [self.emptyView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView);
        make.bottom.mas_equalTo(-66);
        make.height.mas_equalTo(19);
    }];
    label.tag = 1001;

    [self.view layoutIfNeeded];
}


- (void)handleGetDataErrorWithHudMsg:(NSString *)hudmsg emptyViewMsg:(NSString *)emptyViewMsg acion:(SEL _Nullable)action
{
    if (self.tableView.mj_footer.isRefreshing) {
        // 尾部刷新
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:hudmsg.length > 0 ? hudmsg : @"请求失败"];

    } else {
        [self.tableView.mj_header endRefreshing];
        [self showErrorEmptyViewWithText:emptyViewMsg acion:action];
    }
}

- (void)dealloc
{
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
