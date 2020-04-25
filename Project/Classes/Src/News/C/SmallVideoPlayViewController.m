//
//  SmallVideoPlayViewController.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2019/1/5.
//  Copyright © 2019年 duoduo. All rights reserved.
//

#import "SmallVideoPlayViewController.h"
#import "KB_NearVideoPlayCell.h"
#import "DDVideoPlayerManager.h"
#import "SDImageCache.h"
#import "CommentsPopView.h"

static NSString * const NearVideoCellIdentifier = @"NearVideoCellIdentifier";


@interface SmallVideoPlayViewController ()<UITableViewDataSource, UITableViewDelegate, ZFManagerPlayerDelegate, NearVideoPlayCellDlegate, QMUITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView      *bottomView;
@property (nonatomic, strong) QMUITextField *commentTextField;
@property (nonatomic, strong) QMUIButton   *commentBtn;
@property (nonatomic, strong) UIView *fatherView;
//这个是播放视频的管理器
@property (nonatomic, strong) DDVideoPlayerManager *videoPlayerManager;
//这个是预加载视频的管理器
@property (nonatomic, strong) DDVideoPlayerManager *preloadVideoPlayerManager;

@end

@implementation SmallVideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 使用这个内容会上上移
    //[self.view openKeyboardOffsetView];
    [self createUI];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.videoPlayerManager autoPause];
    //[self dismiss];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self.videoPlayerManager autoPlay];
    //[self showToView:self.view];
}

//设置导航栏背景色
- (UIImage *)navigationBarBackgroundImage{
   return [[UIImage alloc] init];
}

- (void)createUI {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.pagingEnabled = YES;
    self.tableView.scrollsToTop = NO;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = SCREEN_HEIGHT - TabBarHeight;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView registerClass:[KB_NearVideoPlayCell class] forCellReuseIdentifier:NearVideoCellIdentifier];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.with.offset(0);
        make.height.offset(SCREEN_HEIGHT - TabBarHeight);
    }];
    if(@available(iOS 11.0, *)){
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentPlayIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playIndex:self.currentPlayIndex];
        if(self.modelArray.count > (self.currentPlayIndex + 1)) {
            [self preLoadIndex:self.currentPlayIndex + 1];
        }
    });
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor  = UIColorMakeWithHex(@"#222222");
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.with.offset(0);
        make.height.offset(TabBarHeight);
    }];
    
    self.commentTextField = [QMUITextField new];
    self.commentTextField.delegate = self;
    self.commentTextField.placeholder = @"说点什么吧～";
    self.commentTextField.maximumTextLength = 55;
    self.commentTextField.returnKeyType = UIReturnKeyDone;
    self.commentTextField.placeholderColor = UIColorMakeWithHex(@"#666666");
    self.commentTextField.textColor = UIColorMakeWithHex(@"#FFFFFF");
    self.commentTextField.font = UIFontMake(14);
    self.commentTextField.backgroundColor = UIColorMakeWithHex(@"#222222");
    [self.view addSubview:self.commentTextField];
    [self.commentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(SCREEN_WIDTH - 20);
        make.left.offset(10);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(10);
        make.height.offset(40);
    }];
    
    
}

#pragma mrak - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KB_NearVideoPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:NearVideoCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.videoModel = self.modelArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT - TabBarHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 默认不实现
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    DLog(@"快点播放下一个");
    NSInteger currentIndex = round(self.tableView.contentOffset.y / SCREEN_HEIGHT);
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
    CGFloat currentIndex = self.tableView.contentOffset.y / SCREEN_HEIGHT;
    if(fabs(currentIndex - self.currentPlayIndex)>1) {
        [self.videoPlayerManager resetPlayer];
        [self.preloadVideoPlayerManager resetPlayer];
    }
}

- (void)playIndex:(NSInteger)currentIndex {
    DLog(@"播放下一个");
    KB_NearVideoPlayCell *currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
    
    NSString *artist = nil;
    NSString *title = nil;
    NSString *cover_url = nil;
    NSURL *videoURL = nil;
    NSURL *originVideoURL = nil;
    BOOL useDownAndPlay = NO;
    AVLayerVideoGravity videoGravity = AVLayerVideoGravityResizeAspect;
    
    
    KB_HomeVideoDetailModel *currentPlaySmallVideoModel = self.modelArray[currentIndex];
    
    artist = currentPlaySmallVideoModel.nickName;
    title = currentPlaySmallVideoModel.videoDesc;
    // 首帧图
    cover_url = [NSString stringWithFormat:@"https://www.lotcloudy.com/scetc-show-videos-mini-api-0.0.1-SNAPSHOT%@",currentPlaySmallVideoModel.coverPath];
    // 视频地址
    videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAddressUrl,currentPlaySmallVideoModel.videoPath]];
    originVideoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAddressUrl,currentPlaySmallVideoModel.videoPath]];
    useDownAndPlay = YES;
    if((currentPlaySmallVideoModel.videoHeight / currentPlaySmallVideoModel.videoWidth) >= 1.4) {
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
    
    KB_HomeVideoDetailModel *currentPlaySmallVideoModel = self.modelArray[index];
    
    artist = currentPlaySmallVideoModel.nickName;
    title = currentPlaySmallVideoModel.videoDesc;
    // 首帧图
    cover_url = [NSString stringWithFormat:@"%@%@",kAddressUrl,currentPlaySmallVideoModel.coverPath];
    // 视频地址
    videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAddressUrl,currentPlaySmallVideoModel.videoPath]];
    originVideoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAddressUrl,currentPlaySmallVideoModel.videoPath]];
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



#pragma mark - NearVideoPlayCellDlegate

//评论
- (void)handleCommentVidieoModel:(KB_HomeVideoDetailModel *)model{
    CommentsPopView *popView = [[CommentsPopView alloc] initWithVideoModel:model];
    [popView showToView:self.view];
}

//关注
- (void)handleAddConcerWithVideoModel:(KB_HomeVideoDetailModel *)model{
    KB_HomeVideoDetailModel *videoModel = model;
    videoModel.isFoucs = YES;
    self.modelArray[self.currentPlayIndex] = videoModel;
}


//点赞
- (void)handleFavoriteVdieoModel:(KB_HomeVideoDetailModel *)model{
    
    
}
//取消点赞
- (void)handleDeleteFavoriteVdieoModel:(KB_HomeVideoDetailModel *)model{
    
    
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

#pragma mark - Action
- (void) backToPreviousView:(id)sender;
{
    [self.videoPlayerManager resetPlayer];
    [self.preloadVideoPlayerManager resetPlayer];
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - QMUItextFieldDelegate-
- (void)textField:(QMUITextField *)textField didPreventTextChangeInRange:(NSRange)range replacementString:(NSString *)replacementString{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最大不超过%@个字符",@(self.commentTextField.maximumTextLength)]];
}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    
}
@end
