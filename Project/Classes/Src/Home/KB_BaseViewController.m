//
//  KB_BaseViewController.m
//  Project
//
//  Created by hi  kobe on 2020/4/6.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_BaseViewController.h"
#import "SmallVideoPlayCell.h"
#import "SmallVideoModel.h"
#import "DDVideoPlayerManager.h"
#import "SDImageCache.h"
#import "CommentsPopView.h"
#import "KB_HomeVideoDetailModel.h"
#import "UIViewController+ZJScrollPageController.h"

static NSString * const SmallVideoCellIdentifier = @"SmallVideoCellIdentifier";
#define cellHeight SCREEN_HEIGHT - TabBarHeight

@interface KB_BaseViewController ()<UITableViewDataSource, UITableViewDelegate, ZFManagerPlayerDelegate, SmallVideoPlayCellDlegate>
@property (nonatomic, strong) UIView *fatherView;
//这个是播放视频的管理器
@property (nonatomic, strong) DDVideoPlayerManager *videoPlayerManager;
//这个是预加载视频的管理器
@property (nonatomic, strong) DDVideoPlayerManager *preloadVideoPlayerManager;
@property (nonatomic, strong) UISwipeGestureRecognizer *recognize;

@end

@implementation KB_BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    self.page = 1;
    // 添加下拉刷新手势
    self.recognize = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pullDownToRefresh)];
    self.recognize.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:self.recognize];
    [self getDataList];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.videoPlayerManager autoPause];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self.videoPlayerManager autoPlay];
}
- (void)pullDownToRefresh{
    LQLog(@"tableview 下拉刷新");
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index{

}

- (void)createUI {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.pagingEnabled = YES;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = SCREEN_HEIGHT - TabBarHeight;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.backgroundColor = UIColorMakeWithHex(@"#222222");
    [self.tableView registerClass:[SmallVideoPlayCell class] forCellReuseIdentifier:SmallVideoCellIdentifier];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view).offset(0);
        make.height.offset(SCREEN_HEIGHT - TabBarHeight);
    }];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentPlayIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playIndex:self.currentPlayIndex];
        if(self.modelArray.count > (self.currentPlayIndex + 1)) {
            [self preLoadIndex:self.currentPlayIndex + 1];
        }
    });
    
}

#pragma mrak - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SmallVideoPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:SmallVideoCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.backgroundColor = UIColorMakeWithHex(@"#222222");
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT - TabBarHeight;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    DLog(@"快点播放下一个");
    NSInteger currentIndex = round(self.tableView.contentOffset.y / (SCREEN_HEIGHT - TabBarHeight));
    if(self.currentPlayIndex != currentIndex) {
        if(self.currentPlayIndex > currentIndex) {
            [self preLoadIndex:currentIndex-1];
        } else if(self.currentPlayIndex < currentIndex) {
            [self preLoadIndex:currentIndex+1];
        }
        self.currentPlayIndex = currentIndex;
        DLog(@"播放下一个");
        [self playIndex:self.currentPlayIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat currentIndex = self.tableView.contentOffset.y / (SCREEN_HEIGHT - TabBarHeight);
    if(fabs(currentIndex - self.currentPlayIndex)>1) {
        [self.videoPlayerManager resetPlayer];
        [self.preloadVideoPlayerManager resetPlayer];
    }
}

- (void)playIndex:(NSInteger)currentIndex {
    DLog(@"播放下一个");
    SmallVideoPlayCell *currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
    
    NSString *artist = nil;
    NSString *title = nil;
    NSString *cover_url = nil;
    NSURL *videoURL = nil;
    NSURL *originVideoURL = nil;
    BOOL useDownAndPlay = NO;
    AVLayerVideoGravity videoGravity = AVLayerVideoGravityResizeAspect;
    
    //关注,推荐
    SmallVideoModel *currentPlaySmallVideoModel = self.modelArray[currentIndex];
    
    artist = currentPlaySmallVideoModel.artist;
    title = currentPlaySmallVideoModel.name;
    cover_url = currentPlaySmallVideoModel.cover_url;
    videoURL = [NSURL URLWithString:currentPlaySmallVideoModel.video_url];
    originVideoURL = [NSURL URLWithString:currentPlaySmallVideoModel.video_url];
    useDownAndPlay = YES;
    if(currentPlaySmallVideoModel.aspect >= 1.4) {
        videoGravity = AVLayerVideoGravityResizeAspectFill;
    } else {
        videoGravity = AVLayerVideoGravityResizeAspect;
    }
    
    self.fatherView = currentCell.playerFatherView;
    self.videoPlayerManager.playerModel.videoGravity = videoGravity;
    self.videoPlayerManager.playerModel.fatherView       = self.fatherView;
    self.videoPlayerManager.playerModel.title            = title;
    self.videoPlayerManager.playerModel.artist = artist;
    self.videoPlayerManager.playerModel.placeholderImageURLString = cover_url;
    self.videoPlayerManager.playerModel.videoURL         = videoURL;
    self.videoPlayerManager.originVideoURL = originVideoURL;
    self.videoPlayerManager.playerModel.useDownAndPlay = YES;
    //如果设备存储空间不足200M,那么不要边下边播
    if([self deviceFreeMemorySize] < 200) {
        self.videoPlayerManager.playerModel.useDownAndPlay = NO;
    }
    [self.videoPlayerManager resetToPlayNewVideo];
}

- (CGFloat)deviceFreeMemorySize {
    /// 总大小
    float totalsize = 0.0;
    /// 剩余大小
    float freesize = 0.0;
    /// 是否登录
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary)
    {
        NSNumber *_free = [dictionary objectForKey:NSFileSystemFreeSize];
        freesize = [_free unsignedLongLongValue]*1.0/(1024);
        
        NSNumber *_total = [dictionary objectForKey:NSFileSystemSize];
        totalsize = [_total unsignedLongLongValue]*1.0/(1024);
    } else
    {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    return freesize/1024.0;
}

//预加载
- (void)preLoadIndex:(NSInteger)index {
    [self.preloadVideoPlayerManager resetPlayer];
    if(self.modelArray.count <= index || [self deviceFreeMemorySize] < 200  || index<0) {
        return;
    }
    NSString *artist = nil;
    NSString *title = nil;
    NSString *cover_url = nil;
    NSURL *videoURL = nil;
    NSURL *originVideoURL = nil;
    BOOL useDownAndPlay = NO;
    
    
    SmallVideoModel *currentPlaySmallVideoModel = self.modelArray[index];
    artist = currentPlaySmallVideoModel.artist;
    title = currentPlaySmallVideoModel.name;
    cover_url = currentPlaySmallVideoModel.cover_url;
    videoURL = [NSURL URLWithString:currentPlaySmallVideoModel.video_url];
    originVideoURL = [NSURL URLWithString:currentPlaySmallVideoModel.video_url];
    useDownAndPlay = YES;
    
    self.preloadVideoPlayerManager.playerModel.title            = title;
    self.preloadVideoPlayerManager.playerModel.artist = artist;
    self.preloadVideoPlayerManager.playerModel.placeholderImageURLString = cover_url;
    self.preloadVideoPlayerManager.playerModel.videoURL         = videoURL;
    self.preloadVideoPlayerManager.originVideoURL = originVideoURL;
    self.preloadVideoPlayerManager.playerModel.useDownAndPlay = YES;
    self.preloadVideoPlayerManager.playerModel.isAutoPlay = NO;
    [self.preloadVideoPlayerManager resetToPlayNewVideo];
}



#pragma mark - SmallVideoPlayCellDlegate

//评论
- (void)handleCommentVidieoModel:(SmallVideoModel *)smallVideoModel {
    
//    ZJVc6Controller *vc = [[ZJVc6Controller alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CommentsPopView *popView = [[CommentsPopView alloc] initWithSmallVideoModel:smallVideoModel];
    [popView showToView:window];
}

- (void)handleShareVideoModel:(SmallVideoModel *)smallVideoModel{
    QMUIMoreOperationController *moreOperationController = [[QMUIMoreOperationController alloc] init];
    moreOperationController.cancelButtonTitleColor = UIColorMakeWithHex(@"#999999");
    moreOperationController.items = @[
                                     // 第一行
                                     @[
                                         [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareFriend") title:@"分享到微信" handler:^(QMUIMoreOperationController * _Nonnull moreOperationController, QMUIMoreOperationItemView * _Nonnull itemView) {
                                             [moreOperationController hideToBottom];
                                         }],
                                         [QMUIMoreOperationItemView itemViewWithImage:UIImageMake(@"icon_moreOperation_shareMoment") title:@"分享到朋友圈" handler:^(QMUIMoreOperationController * _Nonnull moreOperationController, QMUIMoreOperationItemView * _Nonnull itemView) {
                                             [moreOperationController hideToBottom];
                                         }
                                         ]
                                     ],
    ];
    [moreOperationController showFromBottom];
}

#pragma mark - LazyLoad

- (DDVideoPlayerManager *)videoPlayerManager {
    if(!_videoPlayerManager) {
        _videoPlayerManager = [[DDVideoPlayerManager alloc] init];
        _videoPlayerManager.managerDelegate = self;
    }
    return _videoPlayerManager;
}

- (DDVideoPlayerManager *)preloadVideoPlayerManager {
    if(!_preloadVideoPlayerManager) {
        DLog(@"%@",self);
        _preloadVideoPlayerManager = [[DDVideoPlayerManager alloc] init];
    }
    return _preloadVideoPlayerManager;
}

#pragma mark - dealloc
- (void)dealloc {
    [self.videoPlayerManager resetPlayer];
    [self.preloadVideoPlayerManager resetPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getDataList{
    if (self.page == 1) {
        [self showEmptyViewWithLoading];
    }
    NSString *url = [NSString stringWithFormat:@"/video/showAll?page=%@&isSaveRecord=0&category=define",@(self.page)];
    [RequesetApi requestAPIWithParams:nil andRequestUrl:url completedBlock:^(ApiResponseModel *apiResponseModel, BOOL isSuccess) {
        if (isSuccess) {
            [self hideEmptyView];
            //[self.collectionView.mj_header endRefreshing];
//            NSMutableArray *datas = [NSArray modelArrayWithClass:[KB_HomeVideoDetailModel class] json:apiResponseModel.data[@"rows"]].mutableCopy;
//            if (self.page == 1) {
//                [self.modelArray removeAllObjects];
//                self.modelArray = datas;
//            }else{
//                [self.modelArray addObjectsFromArray:datas];
//            }
//            if (datas.count == 5) {
//                //有下一页
//                self.tableView.mj_footer.hidden = NO;
//                [self.tableView.mj_footer endRefreshing];
//                self.page++;
//            }else{
//                self.tableView.mj_footer.hidden = YES;
//            }
//            if (self.modelArray.count == 0) {
//                [self showNoDataEmptyViewWithText:@"暂无数据" detailText:@""];
//            }else{
//                [self.tableView reloadData];
//            }
            
        } else {
            [self hideEmptyView];
            self.tableView.mj_footer.hidden = YES;
            [self.tableView.mj_header endRefreshing];
            [self showEmptyViewWithImage:UIImageMake(@"404") text:@"" detailText:@"加载失败" buttonTitle:@"点击重试" buttonAction:@selector(getDataList)];
        }
    }];
}
@end
