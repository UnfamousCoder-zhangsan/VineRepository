//
//  KB_BaseTableListViewController.m
//  Project
//
//  Created by hualv on 2020/4/21.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_BaseTableListViewController.h"
#import "SmallVideoPlayCell.h"
#import "SmallVideoModel.h"
#import "DDVideoPlayerManager.h"
#import "SDImageCache.h"
#import "CommentsPopView.h"
#import "KB_HomeVideoDetailModel.h"

static NSString * const SmallVideoCellIdentifier = @"SmallVideoCellIdentifier";
@interface KB_BaseTableListViewController ()<ZFManagerPlayerDelegate, SmallVideoPlayCellDlegate>

@property (nonatomic, strong) UIImageView  *loadingView;
@property (nonatomic, strong) UILabel      *loadLabel;
/// 记录当前播放的视频
@property (nonatomic, assign) NSInteger currentPlayIndex;
@property (nonatomic, strong) UIView *fatherView;
///这个是播放视频的管理器
@property (nonatomic, strong) DDVideoPlayerManager *videoPlayerManager;
///这个是预加载视频的管理器
@property (nonatomic, strong) DDVideoPlayerManager *preloadVideoPlayerManager;
///视频数据
@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, copy) void(^listScrollViewScrollCallback)(UIScrollView *scrollView);

@end

@implementation KB_BaseTableListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPlayIndex = 0;
    
    if (self.shouldLoadData) {
         [self.tableView addSubview:self.loadingView];
         [self.tableView addSubview:self.loadLabel];
         [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerY.equalTo(self.tableView);
             make.centerX.equalTo(self.tableView);
         }];
         
         [self.loadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.loadingView.mas_bottom).offset(10.0f);
             make.centerX.equalTo(self.loadingView);
         }];
         
         //[self loadData];
     }
}

- (void)initTableView{
    [super initTableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.pagingEnabled = YES;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = SCREEN_HEIGHT - TabBarHeight;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
    [self.tableView registerClass:[SmallVideoPlayCell class] forCellReuseIdentifier:SmallVideoCellIdentifier];

    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.with.offset(0);
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.videoPlayerManager autoPause];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isViewLoaded && self.view.window) {
        //正在显示
        [self.videoPlayerManager autoPlay];
    } else {
        //非正在显示
        [self.videoPlayerManager autoPause];
    }
}
- (void)addHeaderRefresh {
    
    ///网络数据加载
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.tableView.mj_header endRefreshing];
//
//            self.count = 30;
//            [self.tableView reloadData];
//        });
//    }];
}
#pragma mark - GKPageListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.listScrollViewScrollCallback = callback;
}

- (void)showLoading {
    self.loadingView.hidden = NO;
    self.loadLabel.hidden   = NO;
    [self.loadingView startAnimating];
}

- (void)hideLoading {
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
    self.loadLabel.hidden   = YES;
}

- (UIImage *)changeImageWithImage:(UIImage *)image color:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 懒加载
- (UIImageView *)loadingView {
    if (!_loadingView) {
        NSMutableArray *images = [NSMutableArray new];
        for (NSInteger i = 0; i < 4; i++) {
            NSString *imageName = [NSString stringWithFormat:@"cm2_list_icn_loading%ld", i + 1];
            
            UIImage *img = [self changeImageWithImage:[UIImage imageNamed:imageName] color:[UIColor redColor]];
            
            [images addObject:img];
        }
        
        for (NSInteger i = 4; i > 0; i--) {
            NSString *imageName = [NSString stringWithFormat:@"cm2_list_icn_loading%zd", i];
            
            UIImage *img = [self changeImageWithImage:[UIImage imageNamed:imageName] color:[UIColor redColor]];
            
            [images addObject:img];
        }
        
        UIImageView *loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
        loadingView.animationImages     = images;
        loadingView.animationDuration   = 0.75;
        loadingView.hidden              = YES;
        
        _loadingView = loadingView;
    }
    return _loadingView;
}

- (UILabel *)loadLabel {
    if (!_loadLabel) {
        _loadLabel              = [UILabel new];
        _loadLabel.font         = [UIFont systemFontOfSize:14.0f];
        _loadLabel.textColor    = [UIColor grayColor];
        _loadLabel.text         = @"正在加载...";
        _loadLabel.hidden       = YES;
    }
    return _loadLabel;
}
#pragma mrak - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = self.count == 0;
    return self.modelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SmallVideoPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:SmallVideoCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
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
@end
