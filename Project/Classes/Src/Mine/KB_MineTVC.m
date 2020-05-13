//
//  KB_MineTVC.m
//  Project
//
//  Created by hi  kobe on 2020/4/6.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_MineTVC.h"
#import "KB_MineHeaderView.h"
#import "KB_PersonalInformationVC.h"
#import "KB_SettingInformationVC.h"
#import "KB_BaseCollectionListViewController.h"
#import "InformationModel.h"

@interface KB_MineTVC ()<GKPageScrollViewDelegate, JXCategoryViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) GKPageScrollView      *pageScrollView;

@property (nonatomic, strong) KB_MineHeaderView        *headerView;

@property (nonatomic, strong) JXCategoryTitleView   *categoryView;

@property (nonatomic, strong) NSArray               *titles;

/// titleView
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
        make.top.right.left.with.offset(0);
        make.height.with.offset(self.otherHome ? SCREEN_HEIGHT : SCREEN_HEIGHT - TabBarHeight);
    }];
    
    [self.pageScrollView reloadData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getInformationData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    PageRout_Maneger.currentNaviVC = self.navigationController;
}
- (void)setupNavigationItems{
    [super setupNavigationItems];
    if (!self.otherHome) {
            self.settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.settingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.settingBtn setBackgroundImage:UIImageMake(@"mine_setting") forState:UIControlStateNormal];
        [self.settingBtn addTarget:self action:@selector(gotoSettingVC) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:self.settingBtn];
    }
}

- (void)handleSettingEvent{
    // 跳转设置界面
    KB_PersonalInformationVC *vc = [[UIStoryboard storyboardWithName:@"PersonalInformation" bundle:nil] instantiateViewControllerWithIdentifier:@"KB_PersonalInformationVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

///导航栏背景色
- (UIImage *)navigationBarBackgroundImage{
    return [UIImage imageWithColor:[UIColor clearColor]];
}

#pragma mark - GKPageScrollViewDelegate
- (BOOL)shouldLazyLoadListInPageScrollView:(GKPageScrollView *)pageScrollView{
    return YES;
}

- (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.headerView;
}
- (UIView *)segmentedViewInPageScrollView:(GKPageScrollView *)pageScrollView{
    return self.categoryView;
}

- (NSInteger)numberOfListsInPageScrollView:(GKPageScrollView *)pageScrollView{
    return self.titles.count;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView isMainCanScroll:(BOOL)isMainCanScroll {
    // 导航栏显隐
    CGFloat offsetY = scrollView.contentOffset.y;
    
    
    CGFloat alpha = 0;
    if (offsetY < 200) {
        alpha = 0;
    }else if (offsetY > ((SCREEN_WIDTH * 375.0f / 345.0f) - NavigationBarHeight)) {
        alpha = 1;
    }else {
        alpha = (offsetY - 200) / ((SCREEN_WIDTH * 375.0f / 345.0f) - NavigationBarHeight - 200);
    }
    //self.titleview.alpha = alpha;

    [self.headerView scrollViewDidScroll:offsetY];
}
- (id<GKPageListViewDelegate>)pageScrollView:(GKPageScrollView *)pageScrollView initListAtIndex:(NSInteger)index{
    KB_BaseCollectionListViewController *listVC = [KB_BaseCollectionListViewController new];
    listVC.shouldLoadData = YES;
    [self addChildViewController:listVC];
    return listVC;
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
        _pageScrollView.isLazyLoadList = YES;
    }
    return _pageScrollView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[KB_MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMineHeaderHeight)];
    }
    return _headerView;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"作品", @"喜欢"];
    }
    return _titles;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.0f)];
        _categoryView.backgroundColor = UIColorMakeWithHex(@"#222222");
        _categoryView.contentEdgeInsetLeft = 0;
        _categoryView.contentEdgeInsetRight = 0;
        _categoryView.cellSpacing = 0;
        _categoryView.cellWidth = SCREEN_WIDTH / 2;
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
        
        // 设置关联的scrollview
        _categoryView.contentScrollView = self.pageScrollView.listContainerView.collectionView;
        
        // 添加分割线
        UIView *btmLineView = [UIView new];
        btmLineView.frame = CGRectMake(0, 40 - 0.5, SCREEN_WIDTH, 0.5);
        btmLineView.backgroundColor = UIColorMakeWithHex(@"#233232");
        [_categoryView addSubview:btmLineView];
    }
    return _categoryView;
}

- (UILabel *)titleview {
    if (!_titleview) {
        _titleview = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
        _titleview.font = [UIFont systemFontOfSize:18.0f];
        _titleview.textColor = [UIColor whiteColor];
        _titleview.alpha = 0;
    }
    return _titleview;
}
- (void)gotoSettingVC{
    //跳转设置
    KB_SettingInformationVC *vc = [[UIStoryboard storyboardWithName:@"Setting" bundle:nil] instantiateViewControllerWithIdentifier:@"KB_SettingInformationVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -获取网络数据-
- (void)getInformationData{
    [RequesetApi requestAPIWithParams:nil andRequestUrl:[NSString stringWithFormat:@"/user/query?userId=%@",self.userId? self.userId:User_Center.id] completedBlock:^(ApiResponseModel *apiResponseModel, BOOL isSuccess) {
        if (isSuccess) {
            // 请求成功
            InformationModel *model = [InformationModel modelWithDictionary:apiResponseModel.data];
            self.headerView.model = model;
        } else {
            //加载失败
            [SVProgressHUD showErrorWithStatus:apiResponseModel.msg];
        }
    }];
}
@end
