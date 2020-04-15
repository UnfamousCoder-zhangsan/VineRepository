//
//  KB_HomePageViewController.m
//  Project
//
//  Created by hi  kobe on 2020/3/30.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_HomePageViewController.h"
#import "KB_BaseViewController.h"
#import "SmallVideoModel.h"

@interface KB_HomePageViewController ()<UIScrollViewDelegate, GKPageScrollViewDelegate>
@property(nonatomic, strong) JXCategoryTitleView *categoryView;

@property (nonatomic, strong) UIImageView        *headerView;
@property (nonatomic,strong) UIView              *pageView;

@property (nonatomic, strong) NSMutableArray<SmallVideoModel *> *modelArray;

@end

@implementation KB_HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.categoryView  =[[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, NavigationBarHeight)];
    self.categoryView.backgroundColor = [UIColor clearColor];    
    //配置JXCategoryTitleView的属性
    self.categoryView.titles = @[@"关注",@"推荐"];
    self.categoryView.titleFont = [UIFont systemFontOfSize:16];
    self.categoryView.titleSelectedFont = [UIFont systemFontOfSize:18];
    self.categoryView.titleColor = UIColorMakeWithHex(@"#999999"); //默认颜色
    self.categoryView.titleSelectedColor = [UIColor whiteColor]; //选中颜色
    self.categoryView.defaultSelectedIndex = 1;
    self.categoryView.titleColorGradientEnabled = YES;
    //添加指示器
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor whiteColor];
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.contentScrollView = self.contentScrollView;
    self.navigationItem.titleView = self.categoryView;
    [self.view addSubview:self.pageScrollView];
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.pageScrollView reloadData];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (UIImage *)navigationBarBackgroundImage{
    return [UIImage new];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    PageRout_Maneger.currentNaviVC = self.navigationController;
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
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView isMainCanScroll:(BOOL)isMainCanScroll{
    
    if (scrollView.contentOffset.y < NavigationContentTopConstant) {
        LQLog(@"%@",@(scrollView.contentOffset.y));
        ///禁止下拉
        self.pageScrollView.mainTableView.bounces = NO;
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewWillBeginScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.pageScrollView horizonScrollViewDidEndedScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewDidEndedScroll];
}
#pragma mark - 懒加载
- (GKPageScrollView *)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[GKPageScrollView alloc] initWithDelegate:self];
    }
    return _pageScrollView;
}
- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.clipsToBounds = YES;
        _headerView.image = [UIImage imageNamed:@"test"];
    }
    return _headerView;
}

- (UIView *)pageView {
    if (!_pageView) {
        _pageView = [UIView new];
        
        [_pageView addSubview:self.contentScrollView];
    }
    return _pageView;
}
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        CGFloat scrollW = SCREEN_WIDTH;
        CGFloat scrollH = SCREEN_HEIGHT  - TabBarHeight + NavigationContentTopConstant;
        
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -NavigationContentTopConstant, scrollW, scrollH)];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.delegate = self;
        
        [self.childVCs enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addChildViewController:vc];
            [self->_contentScrollView addSubview:vc.view];
            
            vc.view.frame = CGRectMake(idx * scrollW, 0, scrollW, scrollH);
        }];
        _contentScrollView.contentSize = CGSizeMake(scrollW * self.childVCs.count, 0);
    }
    return _contentScrollView;
}

- (NSArray *)childVCs {
    if (!_childVCs) {
        [self getResource];
        KB_BaseViewController *recommendVC = [KB_BaseViewController new];
        recommendVC.modelArray = self.modelArray;
        recommendVC.isAutoPlay = NO;
        recommendVC.currentPlayIndex = 0;
        
        KB_BaseViewController *focusVC = [KB_BaseViewController new];
        focusVC.modelArray = self.modelArray;
        focusVC.isAutoPlay = NO;
        focusVC.currentPlayIndex = 0;
        
        _childVCs = @[focusVC, recommendVC];
    }
    return _childVCs;
}
#pragma mark - 添加参数-
- (NSMutableArray *)modelArray {
    if(!_modelArray) {
        _modelArray = [NSMutableArray array];
        
    }
    return _modelArray;
}
- (void)getResource {
    SmallVideoModel *model1 = [[SmallVideoModel alloc] init];
    model1.rid = 1;
    model1.name = @"model1";
    model1.comment_num = 12;
    model1.score = 11;
    model1.artist = @"作者1";
    model1.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/46/user_head_30881645_20190423071746.jpg";
    model1.video_url = @"http://119.29.34.133:8080/181228CCZMTR1YFW/video/tmp_5971da7f8211b61731a08148b1131254fe5cd914362e803e.mp4";
    //@"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/551/76097551.mp4";
    model1.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/551/76097551.jpg";
    model1.aspect = 1.778;
    
    SmallVideoModel *model2 = [[SmallVideoModel alloc] init];
    model2.rid = 2;
    model2.name = @"model2";
    model2.comment_num = 12;
    model2.score = 21;
    model2.artist = @"作者2";
    model2.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/46/user_head_30881645_20190423071746.jpg";
    model2.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/479/76097479.mp4";
    model2.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/479/76097479.jpg";
    model2.aspect = 1.778;
    
    SmallVideoModel *model3 = [[SmallVideoModel alloc] init];
    model3.rid = 3;
    model3.name = @"model1";
    model3.comment_num = 12;
    model3.score = 31;
    model3.artist = @"作者3";
    model3.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/31/user_head_34964288_20190212001831.jpg";
    model3.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/970/75779970.mp4";
    model3.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/970/75779970.jpg";
    model3.aspect = 1.778;
    
    SmallVideoModel *model4 = [[SmallVideoModel alloc] init];
    model4.rid = 4;
    model4.name = @"model4";
    model4.comment_num = 12;
    model4.score = 41;
    model4.artist = @"作者4";
    model4.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/22/user_head_27430048_20190525064122.jpg";
    model4.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/204/76097204.mp4";
    model4.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/204/76097204.jpg";
    model4.aspect = 1.250;
    
    SmallVideoModel *model5 = [[SmallVideoModel alloc] init];
    model5.rid = 5;
    model5.name = @"model1";
    model5.comment_num = 12;
    model5.score = 51;
    model5.artist = @"作者5";
    model5.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/13/user_head_15486360_20190426173413.jpg";
    model5.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/022/76097022.mp4";
    model5.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/022/76097022.jpg";
    model5.aspect = 1.799;
    
    SmallVideoModel *model6 = [[SmallVideoModel alloc] init];
    model6.rid = 6;
    model6.name = @"model6";
    model6.comment_num = 12;
    model6.score = 61;
    model6.artist = @"作者6";
    model6.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/55/user_head_5925183_20190528092255.jpg";
    model6.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/550/76097550.mp4";
    model6.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/550/76097550.jpg";
    model6.aspect = 0.567;
    
    SmallVideoModel *model7 = [[SmallVideoModel alloc] init];
    model7.rid = 7;
    model7.name = @"model1";
    model7.comment_num = 12;
    model7.score = 71;
    model7.artist = @"作者7";
    model7.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/43/user_head_123737_20190424101443.jpg";
    model7.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/488/75779488.mp4";
    model7.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/488/75779488.jpg";
    model7.aspect = 0.562;
    
    SmallVideoModel *model8 = [[SmallVideoModel alloc] init];
    model8.rid = 8;
    model8.name = @"model1";
    model8.comment_num = 12;
    model8.score = 81;
    model8.artist = @"作者8";
    model8.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model8.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/809/76096809.mp4";
    model8.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/809/76096809.jpg";
    model8.aspect = 0.562;
    
    SmallVideoModel *model9 = [[SmallVideoModel alloc] init];
    model9.rid = 9;
    model9.name = @"model9";
    model9.comment_num = 12;
    model9.score = 91;
    model9.artist = @"作者9";
    model9.head_url = @"http://thirdqq.qlogo.cn/g?b=oidb&amp;k=IXYXYnjFTRGWV18ibkgC6Kw&amp;s=100";
    model9.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/603/76096603.mp4";
    model9.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/603/76096603.jpg";
    model9.aspect = 1.000;
    
    SmallVideoModel *model10 = [[SmallVideoModel alloc] init];
    model10.rid = 10;
    model10.name = @"model1";
    model10.comment_num = 12;
    model10.score = 101;
    model10.artist = @"作者10";
    model10.head_url = @"http://thirdqq.qlogo.cn/g?b=oidb&amp;k=lzQZzzcCgg8j4XvcyPBGOA&amp;s=100";
    model10.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/059/75778059.mp4";
    model10.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/059/75778059.jpg";
    model10.aspect = 1.778;
    
    SmallVideoModel *model11 = [[SmallVideoModel alloc] init];
    model11.rid = 11;
    model11.name = @"model11";
    model11.comment_num = 12;
    model11.score = 111;
    model11.artist = @"作者11";
    model11.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/34/user_head_31365520_20190516093434.jpg";
    model11.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/037/76096037.mp4";
    model11.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/037/76096037.jpg";
    model11.aspect = 1.778;
    
    SmallVideoModel *model12 = [[SmallVideoModel alloc] init];
    model12.rid = 12;
    model12.name = @"model12";
    model12.comment_num = 12;
    model12.score = 121;
    model12.artist = @"作者12";
    model12.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/34/user_head_31365520_20190516093434.jpg";
    model12.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/029/76096029.mp4";
    model12.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/029/76096029.jpg";
    model12.aspect = 1.778;
    [self.modelArray addObjectsFromArray:@[model1,model2,model3,model4,model5,model6,model7,model8,model9,model10,model11,model12]];
}
@end
