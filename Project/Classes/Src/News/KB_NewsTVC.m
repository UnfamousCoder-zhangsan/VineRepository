//
//  KB_NewsTVC.m
//  Project
//
//  Created by hi  kobe on 2020/4/7.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_NewsTVC.h"
#import "DDAnimationLayout.h"
#import "SmallVideoCell.h"
#import "SmallVideoModel.h"
#import "SmallVideoPlayViewController.h"
#import "SmallVideoPlayViewController.h"

#import "KB_HomeVideoDetailModel.h"


static NSString* const SmallVideoCellIdentifier = @"SmallVideoCellIdentifier";

@interface KB_NewsTVC () <UICollectionViewDataSource, UICollectionViewDelegate, DDAnimationLayoutDelegate>

@property (nonatomic, strong) NSMutableArray<KB_HomeVideoDetailModel *> *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation KB_NewsTVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近";
    [self setupBaseView];
    
    self.dataArray = [NSMutableArray array];
    self.page = 1;
    [self getDataList];
    
    @weakify(self)
    [self addPullRefreshWithBlock:^{
        @strongify(self)
        self.dataArray = [NSMutableArray array];
        self.page = 1;
        self.collectionView.mj_footer.hidden = YES;
        [self.collectionView reloadData];
        [self getDataList];
    }];
    [self addLoadingMoreWithBlock:^{
        @strongify(self)
        [self getDataList];
    }];
    
}

- (UIImage *)navigationBarShadowImage{
    return [UIImage imageWithColor:UIColorMakeWithHex(@"#555555")];
}

- (BOOL)preferredNavigationBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    PageRout_Maneger.currentNaviVC = self.navigationController;
}

#pragma mark - SetupBase

- (void)setupBaseView {
    self.view.backgroundColor = UIColorMakeWithHex(@"#444444");
    DDAnimationLayout *layout = [[DDAnimationLayout alloc]init];
    layout.rowsOrColumnsCount = 2;
    layout.rowMargin = 10;
    layout.columnMargin = 5;
    layout.delegate = self;
    layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0 , 0) collectionViewLayout:layout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    //设置数据源和代理
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    //注册
    [collectionView registerClass:[SmallVideoCell class] forCellWithReuseIdentifier:SmallVideoCellIdentifier];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(0);
        make.bottom.with.offset(0);
        make.left.with.offset(0);
        make.right.with.offset(0);
    }];
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
    self.collectionView.mj_header.ignoredScrollViewContentInsetTop = 10;
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
}

- (void)endRefreshWithFooterHidden
{
    [self.collectionView.mj_footer endRefreshing];
    // 通知已经全部加载完毕
    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    self.collectionView.mj_footer.hidden = YES;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}

//创建collectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SmallVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SmallVideoCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SmallVideoPlayViewController *smallVideoPlayViewController = [[SmallVideoPlayViewController alloc] init];
    smallVideoPlayViewController.page = self.page; //用于请求了第几页数据展示下次请求数据直接展示
    smallVideoPlayViewController.modelArray = self.dataArray;
    smallVideoPlayViewController.currentPlayIndex = indexPath.row;
    [PageRout_Maneger.currentNaviVC pushViewController:smallVideoPlayViewController animated:YES];
}

#pragma mark - <DDAnimationLayoutDelegate>
- (CGSize)DDAnimationLayout:(DDAnimationLayout *) layout atIndexPath:(NSIndexPath *) indexPath {
    KB_HomeVideoDetailModel *model = self.dataArray[indexPath.item];
    CGSize size;
    if (model.videoDesc.length > 0) {
        size.height = [model.videoDesc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH / 2 - 30, CGFLOAT_MAX) font:UIFontMake(14) lineSpacing:5].height;
    } else {
        size.height = 0;
    }
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    width = (SCREEN_WIDTH-21) /2;
    height = (SCREEN_WIDTH-1) /2 * (model.videoHeight / model.videoWidth) + size.height + 30;
    return CGSizeMake(width,height);
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (NSMutableArray<KB_HomeVideoDetailModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)getDataList{
    if (self.page == 1) {
        [self showEmptyViewWithLoading];
    }
    NSString *url = [NSString stringWithFormat:@"/video/showAll?page=%@&isSaveRecord=0&category=food",@(self.page)];
    [RequesetApi requestAPIWithParams:nil andRequestUrl:url completedBlock:^(ApiResponseModel *apiResponseModel, BOOL isSuccess) {
        if (isSuccess) {
            [self hideEmptyView];
            [self.collectionView.mj_header endRefreshing];
            NSMutableArray *datas = [NSArray modelArrayWithClass:[KB_HomeVideoDetailModel class] json:apiResponseModel.data[@"rows"]].mutableCopy;
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
                self.dataArray = datas;
            }else{
                [self.dataArray addObjectsFromArray:datas];
            }
            if (datas.count == 5) {
                //有下一页
                self.collectionView.mj_footer.hidden = NO;
                [self.collectionView.mj_footer endRefreshing];
                self.page++;
            }else{
                [self endRefreshWithFooterHidden];
            }
            if (self.dataArray.count == 0) {
                [self showNoDataEmptyViewWithText:@"暂无附近数据" detailText:@"请前往首页观看更多视频"];
            }else{
                [self.collectionView reloadData];
            }
            
        } else {
            [self hideEmptyView];
            self.collectionView.mj_footer.hidden = YES;
            [self.collectionView.mj_header endRefreshing];
            [self showEmptyViewWithImage:UIImageMake(@"404") text:@"" detailText:@"加载失败" buttonTitle:@"点击重试" buttonAction:@selector(getDataList)];
        }
    }];
}

@end
