//
//  KB_MineTVC.m
//  Project
//
//  Created by hi  kobe on 2020/4/6.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_MineTVC.h"
#import "KB_MineHeaderView.h"
#import "KB_ListViewController.h"
#import "KB_PersonalInformationVC.h"
#import "KB_SettingInformationVC.h"

@interface KB_MineTVC ()<GKPageScrollViewDelegate, JXCategoryViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) GKPageScrollView      *pageScrollView;

@property (nonatomic, strong) KB_MineHeaderView        *headerView;

@property (nonatomic, strong) UIView                *pageView;
@property (nonatomic, strong) JXCategoryTitleView   *categoryView;
@property (nonatomic, strong) UIScrollView          *scrollView;

@property (nonatomic, strong) NSArray               *titles;
@property (nonatomic, strong) NSArray               *childVCs;

@property (nonatomic, strong) UILabel               *titleview;

@property (nonatomic, strong) UIButton              *settingBtn;

@end

@implementation KB_MineTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorMakeWithHex(@"#222222");
    /// 单独设置 title
    self.titleView.title = self.titleview.text;
    [self.view addSubview:self.pageScrollView];
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.pageScrollView reloadData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    PageRout_Maneger.currentNaviVC = self.navigationController;
}
- (void)setupNavigationItems{
    [super setupNavigationItems];
    self.settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.settingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.settingBtn setBackgroundImage:UIImageMake(@"mine_setting") forState:UIControlStateNormal];
    [self.settingBtn addTarget:self action:@selector(gotoSettingVC) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:self.settingBtn];
    //[UIBarButtonItem qmui_itemWithTitle:@"设置" target:self action:@selector(handleSettingEvent)];
}

- (void)handleSettingEvent{
    // 跳转设置界面
    KB_PersonalInformationVC *vc = [[UIStoryboard storyboardWithName:@"PersonalInformation" bundle:nil] instantiateViewControllerWithIdentifier:@"KB_PersonalInformationVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIImage *)navigationBarBackgroundImage{
    return [UIImage imageWithColor:[UIColor clearColor]];
}

#pragma mark - GKPageScrollViewDelegate
- (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.headerView;
}

- (UIView *)pageViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.pageView;
}

- (NSArray<id<GKPageListViewDelegate>> *)listViewsInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.childVCs;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView isMainCanScroll:(BOOL)isMainCanScroll {
    // 导航栏显隐
    CGFloat offsetY = scrollView.contentOffset.y;
    // 0-200 0
    // 200 - KDYHeaderHeigh - kNavBarheight 渐变从0-1
    // > KDYHeaderHeigh - kNavBarheight 1
    CGFloat alpha = 0;
    if (offsetY < 200) {
        alpha = 0;
    }else if (offsetY > ((SCREEN_WIDTH * 375.0f / 345.0f) - NavigationBarHeight)) {
        alpha = 1;
    }else {
        alpha = (offsetY - 200) / ((SCREEN_WIDTH * 375.0f / 345.0f) - NavigationBarHeight - 200);
    }
   // self.gk_navBarAlpha = alpha;
    self.titleView.alpha = alpha;

    [self.headerView scrollViewDidScroll:offsetY];
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"刷新数据");
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewWillBeginScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewDidEndedScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.pageScrollView horizonScrollViewDidEndedScroll];
}

#pragma mark - 懒加载
- (GKPageScrollView *)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[GKPageScrollView alloc] initWithDelegate:self];
    }
    return _pageScrollView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[KB_MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMineHeaderHeight)];
    }
    return _headerView;
}

- (UIView *)pageView {
    if (!_pageView) {
        _pageView = [UIView new];
        _pageView.backgroundColor = [UIColor clearColor];
        
        [_pageView addSubview:self.categoryView];
        [_pageView addSubview:self.scrollView];
    }
    return _pageView;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.0f)];
        _categoryView.backgroundColor = UIColorMakeWithHex(@"#222222");
        _categoryView.titles = self.titles;
        _categoryView.delegate = self;
        _categoryView.titleColor = [UIColor grayColor];
        _categoryView.titleSelectedColor = [UIColor whiteColor];
        _categoryView.titleFont = [UIFont systemFontOfSize:16.0f];
        _categoryView.titleSelectedFont = [UIFont systemFontOfSize:16.0f];
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = [UIColor yellowColor];
        lineView.indicatorWidth = 80.0f;
        lineView.indicatorCornerRadius = 0;
        lineView.lineStyle = JXCategoryIndicatorLineStyle_Normal;
        _categoryView.indicators = @[lineView];
        
        _categoryView.contentScrollView = self.scrollView;
        
        // 添加分割线
        UIView *btmLineView = [UIView new];
        btmLineView.frame = CGRectMake(0, 40 - 0.5, SCREEN_WIDTH, 0.5);
        btmLineView.backgroundColor = UIColorMakeWithHex(@"#233232");
        [_categoryView addSubview:btmLineView];
    }
    return _categoryView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGFloat scrollW = SCREEN_WIDTH;
        CGFloat scrollH = SCREEN_HEIGHT - NavigationBarHeight - 40.0f - TabBarHeight;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, scrollW, scrollH)];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        [self.childVCs enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addChildViewController:vc];
            [self->_scrollView addSubview:vc.view];
            
            vc.view.frame = CGRectMake(idx * scrollW, 0, scrollW, scrollH);
        }];
        _scrollView.contentSize = CGSizeMake(self.childVCs.count * scrollW, 0);
        
    }
    return _scrollView;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"作品 129", @"喜欢 591"];
    }
    return _titles;
}

- (NSArray *)childVCs {
    if (!_childVCs) {
        KB_ListViewController *publishVC = [KB_ListViewController new];
        
       // KB_ListViewController *dynamicVC = [KB_ListViewController new];
        
        KB_ListViewController *lovedVC = [KB_ListViewController new];
        
        _childVCs = @[publishVC, lovedVC];
    }
    return _childVCs;
}

- (UILabel *)titleview {
    if (!_titleview) {
        _titleview = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
        _titleview.font = [UIFont systemFontOfSize:18.0f];
        _titleview.textColor = [UIColor whiteColor];
        _titleview.text = @"会说话的刘二豆";
        _titleview.alpha = 0;
    }
    return _titleview;
}
//- (UIButton *)settingBtn{
//    if (!_settingBtn) {
//
//    }
//    return _settingBtn;
//}
- (void)gotoSettingVC{
    //跳转设置
    KB_SettingInformationVC *vc = [[UIStoryboard storyboardWithName:@"Setting" bundle:nil] instantiateViewControllerWithIdentifier:@"KB_SettingInformationVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
