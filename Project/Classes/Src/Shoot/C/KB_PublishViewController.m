//
//  KB_PublishViewController.m
//  Project
//
//  Created by hi  kobe on 2020/4/19.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_PublishViewController.h"
#import "KB_PublishCell.h"

@interface KB_PublishViewController ()<UITableViewDelegate,UITableViewDataSource,QMUIImagePreviewViewDelegate>{
    QMUIButton *_publishBtn;
    UITableView *_tableView;
}
@property(nonatomic, strong) NSString *titleText;

@property (nonatomic, strong) QMUIImagePreviewViewController *imagePreviewViewController;
/// 保存headerImage
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) BOOL isShow;
@end

@implementation KB_PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布";
    [self initUI];
}
- (void)initUI{
    
    //bottomView
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = UIColorMakeWithHex(@"#222222");
    [self.view addSubview:bottomView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UIColorMakeWithHex(@"#222222");
    [_tableView registerNib:[UINib nibWithNibName:@"KB_PublishCell" bundle:nil] forCellReuseIdentifier:@"KB_PublishCell"];
    [self.view addSubview:_tableView];
    _publishBtn = [[QMUIButton alloc] init];
    [_publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_publishBtn setBackgroundImage:UIImageMake(@"") forState:UIControlStateNormal];
    [_publishBtn setBackgroundColor:UIColorMakeWithHex(@"#FFFFFF")];
    [_publishBtn addTarget:self action:@selector(updateVideoToService) forControlEvents:UIControlEventTouchUpInside];
    _publishBtn.layer.cornerRadius = 5;
    [bottomView addSubview:_publishBtn];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.with.offset(0);
        make.height.with.offset(SafeAreaInsetsConstantForDeviceWithNotch.bottom + 60);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(self.view).offset(0);
        make.bottom.mas_equalTo(bottomView.mas_top).offset(0);
    }];
    [_publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView.mas_top).offset(0);
        make.centerX.mas_equalTo(bottomView.mas_centerX).offset(0);
        make.width.with.offset(SCREEN_WIDTH - 100);
        make.height.with.offset(50);
    }];
}
- (void)setImage:(UIImage *)image{
    _image = image;
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KB_PublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KB_PublishCell"];
    cell.uploadImageView.image = self.image;
    self.imageView = cell.uploadImageView;
    @weakify(self)
    cell.textViewBlock = ^(NSString * str) {
        @strongify(self)
        self.titleText = str;
    };
    cell.imageViewTapBlock = ^{
        @strongify(self)
        [self handleImageBrowseEventWith:self.imageView];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 132;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

#pragma mark - 上传 -
- (void)updateVideoToService{
    
    if (self.titleText.length == 0 && !self.isShow) {
        self.isShow = YES;
        @weakify(self)
        [AlertHelper showAlertMessage:@"你还未填写标题哦" okBlock:^{
             @strongify(self)
            self.isShow = YES;
        }];
        return;
    }
    if (!self.videoUrl) {
        [SVProgressHUD showErrorWithStatus:@"还不能发送图片哦"];
        return;
    }
    AVAsset *asset = [AVAsset assetWithURL:self.videoUrl];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = tracks[0];
    CGSize videoSize = CGSizeApplyAffineTransform(videoTrack.naturalSize, videoTrack.preferredTransform);
    videoSize = CGSizeMake(fabs(videoSize.width), fabs(videoSize.height));
    AVURLAsset*audioAsset = [AVURLAsset URLAssetWithURL:self.videoUrl options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);

    NSDictionary *param = @{@"userId":User_Center.id,@"videoCategory":@"define",@"duration":[NSString stringWithFormat:@"%.1f",audioDurationSeconds],@"tmpHeight":@(videoSize.height),@"videoFilter":@"define",@"tmpCoverUrl":@"",@"desc":self.titleText,@"tmpWidth":@(videoSize.width)};
    [SVProgressHUD showWithStatus:@"上传中"];
    [RequesetApi uploadVideoWith:@"/video/upload" video:self.videoUrl params:param name:@"file" completedBlock:^(ApiResponseModel *apiResponseModel, BOOL isSuccess) {
        if (isSuccess) {
            [SVProgressHUD dismiss];
            [PageRout_Maneger.currentNaviVC dismissViewControllerAnimated:YES completion:^{
                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"上传失败，请重试"];
        }
    }];
}
#pragma mark - 点击查看大图 -
- (void)handleImageBrowseEventWith:(UIView *)view{
    if (!self.imagePreviewViewController) {
        self.imagePreviewViewController = [[QMUIImagePreviewViewController alloc] init];
        self.imagePreviewViewController.presentingStyle = QMUIImagePreviewViewControllerTransitioningStyleZoom;
        self.imagePreviewViewController.imagePreviewView.delegate = self;
        self.imagePreviewViewController.sourceImageView = ^UIView * _Nullable{
            return view;
        };
    }
    [self.navigationController presentViewController:self.imagePreviewViewController animated:YES completion:nil];
}

#pragma mark - QMUIImagePreviewViewDelegate -
- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView{
    return 1;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index{
    // 模拟网络加载
    zoomImageView.image = self.image;
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index{
    return QMUIImagePreviewMediaTypeImage;
}

#pragma mark - QMUIZoomImageViewDelegate -
- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location{
    //退出图片预览
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
