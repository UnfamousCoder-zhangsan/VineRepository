
#import "JWCollectionViewController.h"

@interface JWCollectionViewController()

@end

@implementation JWCollectionViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWhite;
    self.collectionView.backgroundColor = APPColor_BackgroudView;
    //收起键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
}

- (void)viewTapped
{
    [self.view endEditing:YES];
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
    [self.collectionView reloadData];
}

#pragma mark - 添加下拉刷新
- (void)addPullRefreshWithBlock:(void (^)(void))block
{
    @weakify(self)
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.collectionView.mj_footer.hidden = NO;
        if (block) {
            block();
        }
    }];
    ((MJRefreshNormalHeader *)self.collectionView.mj_header).lastUpdatedTimeLabel.hidden = YES;
}

#pragma mark - 上拉加载更多
- (void)addLoadingMoreWithBlock:(void (^)(void))block
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
    self.collectionView.mj_footer = footer;
    // 隐藏刷新时显示文字
    footer.stateLabel.hidden = YES;
}

- (void)endRefreshWithFooterHidden
{
    [self.collectionView.mj_footer endRefreshing];
    // 通知已经全部加载完毕
    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
}

- (void)initSubviews
{
    [super initSubviews];
    [self.view addSubview:self.collectionView];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

@end
