//
//  KB_ShootVC.m
//  Project
//
//  Created by hi  kobe on 2020/4/6.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_ShootVC.h"
#import "LLSimpleCamera.h"

#import "KBPickerScrollerView.h"
#import "CustomPickerItem.h"
#import "KBPickerModel.h"
#import "KB_PublishViewController.h"
#import "KB_CountDownLabel.h"

#define ScreenWith     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight   [UIScreen mainScreen].bounds.size.height


@interface KB_ShootVC () <KBPickerScrollViewDelegate, KBPickerScrollViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) LLSimpleCamera *camera;
///打开闪光灯按钮
@property (nonatomic, strong) QMUIButton *flashOnButton;
///切换前后摄像头
@property (nonatomic, strong) QMUIButton *exchangeCamera;
/// 倒计时
@property (nonatomic, strong) QMUIButton *countDown;
/// 倒计时展示
@property (nonatomic, strong) UILabel    *countDownLabel;
/// 录制进度条
@property (nonatomic, strong) UIProgressView *timeProgressView;

@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
/// 拍摄
@property (strong, nonatomic) UIButton *snapButton;
///  相册选择
@property (strong, nonatomic) UIButton *albumButton;
/// 退出按钮
@property (nonatomic, strong) UIButton *closeButton;
/// 横向选择器
@property (weak, nonatomic) IBOutlet KBPickerScrollerView *pickerScrollView;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 选择了第几种方式
@property (nonatomic, assign) NSInteger selectedIndex;


@end

@implementation KB_ShootVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = UIColorMakeWithHex(@"#222222");
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                 position:LLCameraPositionRear
                                             videoEnabled:YES];
    [self.camera attachToViewController:self withFrame:self.contentView.frame];
    self.camera.fixOrientationAfterCapture = NO;
    self.camera.position = LLCameraPositionFront; //默认前置
    [self setupUI];
    @weakify(self)
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice *device) {
       @strongify(self)
        if ([camera isFlashAvailable]) {
            self.flashOnButton.hidden = NO;
            if (camera.flash == LLCameraFlashOff) {
                self.flashOnButton.selected = NO;
            }else{
                self.flashOnButton.selected = YES;
            }
        }else{
            self.flashOnButton.hidden = YES;
        }
    }];
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
       // @strongify(self) 访问出错
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission ||
               error.code == LLSimpleCameraErrorCodeMicrophonePermission) {
                
//                if(self.errorLabel) {
//                    [self.errorLabel removeFromSuperview];
//                }
//
//                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//                label.text = @"We need permission for the camera.\nPlease go to your settings.";
//                label.numberOfLines = 2;
//                label.lineBreakMode = NSLineBreakByWordWrapping;
//                label.backgroundColor = [UIColor clearColor];
//                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
//                label.textColor = [UIColor whiteColor];
//                label.textAlignment = NSTextAlignmentCenter;
//                [label sizeToFit];
//                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
//                weakSelf.errorLabel = label;
//                [weakSelf.view addSubview:weakSelf.errorLabel];
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.camera start];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (BOOL)preferredNavigationBarHidden
{
    return YES;
}


- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//关闭页面
- (void)closeEvent:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)albumCilckEvent{
    //从相册选择东西
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
        //无权限
        [AlertHelper showAlertMessage:@"无法访问您的相册！请前往系统设置开启应用的相册访问权限！" okBlock:nil];
    } else {
        [self showImagePickerWith:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

#pragma mark - 选择图片 -
- (void)showImagePickerWith:(UIImagePickerControllerSourceType)sourceType {
    BOOL isAlbumAvailable = [UIImagePickerController isSourceTypeAvailable:sourceType];
    if (isAlbumAvailable) {
            UIImagePickerController *profilePicker = [[UIImagePickerController alloc] init];
        profilePicker.modalPresentationStyle = UIModalPresentationPopover;
        profilePicker.sourceType = sourceType;
        // 设置视频格式
        profilePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeMovie, (NSString *) kUTTypeImage,nil];
        profilePicker.allowsEditing = NO;
        profilePicker.delegate = self;
        profilePicker.preferredContentSize = CGSizeMake(512, 512);
        [self.navigationController presentViewController:profilePicker animated:YES completion:nil];
    } else {
        [AlertHelper showAlertMessage:@"无法访问您的相册！请前往系统设置开启应用的相册访问权限！" okBlock:nil];
    }

}
#pragma mark - <QMUIImagePickerViewControllerDelegate>
- (void)imagePickerViewControllerDidCancel:(QMUIImagePickerViewController *)imagePickerViewController{
    [imagePickerViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -imagePicker delegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *editImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL   *editUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    // 当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        KB_PublishViewController *vc = [[KB_PublishViewController alloc] init];
        vc.image = editImg;
        [picker dismissViewControllerAnimated:YES completion:^{
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }else if ([type isEqualToString:@"public.movie"]){
        KB_PublishViewController *vc = [[KB_PublishViewController alloc] init];
        vc.videoUrl = editUrl;
        vc.image = [self getVideoFirstViewImage:editUrl];
        [picker dismissViewControllerAnimated:YES completion:^{
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
}

- (void)flashModeEvent:(UIButton *)sender {
    if(self.camera.flash == LLCameraFlashOff) {
         BOOL done = [self.camera updateFlashMode:LLCameraFlashOn];
         if(done) {
             //打开
             [self.flashOnButton setImage:UIImageMake(@"flash_on") forState:UIControlStateNormal];
         }
     }
     else {
         BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];
         if(done) {
             //关闭
             [self.flashOnButton setImage:UIImageMake(@"flash_off") forState:UIControlStateNormal];
         }
     }
}

- (void)exchangeCameraEvent:(QMUIButton *)sender {
    [UIView transitionWithView:self.exchangeCamera duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [self.camera togglePosition];
    } completion:^(BOOL finished) {
    }];
}

- (void)countDownEvent:(QMUIButton *)sender{
    [KB_CountDownLabel playWithNumber:5 endTitle:@"开始" success:^(KB_CountDownLabel *label) {
        //倒计时结束了
        [self clickShootBtn];
    }];
    
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
#pragma mark - UI相关和布局
- (void)setupUI{
    
    
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapButton.clipsToBounds = YES;
    self.snapButton.layer.cornerRadius = 70 / 2.0f;
    self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.snapButton.layer.borderWidth = 2.0f;
    self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    self.snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.snapButton.layer.shouldRasterize = YES;
    [self.snapButton addTarget:self action:@selector(clickShootBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapButton];
    [self.snapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(70);
        make.centerX.mas_equalTo(self.view.centerX).offset(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    self.albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.albumButton setBackgroundImage:UIImageMake(@"shoot_album") forState:UIControlStateNormal];
    [self.albumButton addTarget:self action:@selector(albumCilckEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.albumButton];
    [self.albumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.with.offset(30);
        make.height.with.offset(30);
        make.centerY.mas_equalTo(self.snapButton.mas_centerY).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
    }];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setBackgroundImage:UIImageMake(@"closePaster_normal") forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(30);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.top.mas_equalTo(self.view.mas_top).offset(NavigationContentTopConstant - 20);
    }];
    
    
    self.exchangeCamera = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.exchangeCamera setTitleColor:UIColorMakeWithHex(@"#FFFFFF") forState:UIControlStateNormal];
    [self.exchangeCamera setImagePosition:QMUIButtonImagePositionTop];
    [self.exchangeCamera setImage:UIImageMake(@"cameraex") forState:UIControlStateNormal];
    [self.exchangeCamera setTitle:@"翻转" forState:UIControlStateNormal];
    self.exchangeCamera.titleLabel.font = UIFontMake(12);
    [self.exchangeCamera addTarget:self action:@selector(exchangeCameraEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.exchangeCamera];
    [self.exchangeCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(50);
        make.height.offset(60);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(self.view.mas_top).offset(NavigationContentTopConstant);
    }];
    
    self.flashOnButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.flashOnButton setImage:UIImageMake(@"flash_off") forState:UIControlStateNormal];
    [self.flashOnButton setImagePosition:QMUIButtonImagePositionTop];
    [self.flashOnButton addTarget:self action:@selector(flashModeEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashOnButton];
    [self.flashOnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(40);
        make.centerX.mas_equalTo(self.exchangeCamera.mas_centerX).offset(0);
        make.top.mas_equalTo(self.exchangeCamera.mas_bottom).offset(20);
    }];
    
    self.countDown = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [self.countDown setImage:UIImageMake(@"CountDown-normal") forState:UIControlStateNormal];
    [self.countDown setImagePosition:QMUIButtonImagePositionTop];
    [self.countDown addTarget:self action:@selector(countDownEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.countDown];
    [self.countDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(50);
        make.height.offset(50);
        make.centerX.mas_equalTo(self.exchangeCamera.mas_centerX).offset(0);
        make.top.mas_equalTo(self.flashOnButton.mas_bottom).offset(20);
    }];
    
    self.pointLabel.layer.cornerRadius = 5;
    self.pointLabel.layer.masksToBounds = YES;
    
    self.contentView.layer.cornerRadius = 10;
    self.dataArray = [NSMutableArray array];
    NSArray *titleArray = @[@"拍照",@"拍15秒",@"拍60秒"];
    for (int i = 0; i < titleArray.count; i++){
        KBPickerModel *model = [[KBPickerModel alloc] init];
        model.title = [titleArray objectAtIndex:i];
        [self.dataArray addObject:model];
    }
    self.pickerScrollView.backgroundColor = [UIColor clearColor];
    self.pickerScrollView.itemWidth = SCREEN_WIDTH / 5;
    self.pickerScrollView.itemHeight = 60;
    self.pickerScrollView.firstItemX = (_pickerScrollView.frame.size.width - _pickerScrollView.itemWidth) * 0.5;
    self.pickerScrollView.dataSource = self;
    self.pickerScrollView.delegate = self;
    // 刷新数据
    [self.pickerScrollView reloadData];
    self.pickerScrollView.selectedIndex = 1;
    [self.pickerScrollView scollToSelectdIndex:1];
}


#pragma mark -KBPickerScrollViewDataSource-
- (NSInteger)numberOfItemAtPickerScrollView:(KBPickerScrollerView *)pickerScrollView{
    return  self.dataArray.count;
}

- (KBPickerItem *)pickerScrollView:(KBPickerScrollerView *)pickerScrollView itemAtIndex:(NSInteger)index{
    CustomPickerItem *item = [[CustomPickerItem alloc] initWithFrame:CGRectMake(0, 0, pickerScrollView.itemWidth, pickerScrollView.itemHeight)];
    KBPickerModel *model = [self.dataArray objectAtIndex:index];
    model.index = index;
    item.title = model.title;
    [item setItemTitleWith:UIColorMakeWithHex(@"#FFFFFF")];
    
    item.PickerItemSelectedBlock = ^(NSInteger index) {
        [self.pickerScrollView scollToSelectdIndex:index];
    };
    return item;
}


#pragma mark -KBPickerScrollViewDelegate-
- (void)itemForIndexChange:(KBPickerItem *)item
{
    [item changeSizeOfItem];
}

- (void)itemForIndexBack:(KBPickerItem *)item
{
    [item backSizeOfItem];
}
- (void)pickerScrollView:(KBPickerScrollerView *)menuScrollView didSelectedItemAtindex:(NSInteger)index{
    if (index == 0) {
        self.flashOnButton.hidden = NO;
        [self updateUI];
        [self.snapButton setImage:UIImageMake(@"take_picture") forState:UIControlStateNormal];
    } else {
        self.flashOnButton.hidden = YES;
        [self updateUI];
        [self.snapButton setImage:UIImageMake(@"shoot_normal") forState:UIControlStateNormal];
    }
    self.selectedIndex = index;
    // 选中震动反馈
    UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [impactLight impactOccurred];
    
}
- (void)updateUI{
    if (!self.flashOnButton.isHidden) {
        [UIView animateWithDuration:0.5 animations:^{
            self.flashOnButton.alpha = 1.0;
            self.countDown.center = CGPointMake(SCREEN_WIDTH - 15 - 25, NavigationContentTopConstant + 120 + 25);
            [self.countDown mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.exchangeCamera.mas_bottom).offset(80);
            }];
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.flashOnButton.alpha = 0.0;
            self.countDown.center = CGPointMake(SCREEN_WIDTH - 15 - 25, NavigationContentTopConstant + 25 + 80);
            [self.countDown mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.exchangeCamera.mas_bottom).offset(20);
            }];
        }];
    }
}
- (void)clickShootBtn {
    // 拍照
    if (self.selectedIndex != 0) {
        if (!self.camera.isRecording) {
            self.flashOnButton.hidden = YES;
            self.exchangeCamera.hidden = YES;
            self.pickerScrollView.hidden = YES;
            self.pointLabel.hidden = YES;
            
            NSURL *outputURL = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"video"] URLByAppendingPathExtension:@"mp4"];
            [self.camera startRecordingWithOutputUrl:outputURL didRecord:^(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error) {
                KB_PublishViewController *vc = [[KB_PublishViewController alloc] init];
                vc.videoUrl = outputURL;
                vc.image = [self getVideoFirstViewImage:outputURL];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        } else {
            self.flashOnButton.hidden = NO;
            self.exchangeCamera.hidden = NO;
            self.pickerScrollView.hidden = NO;
            self.pointLabel.hidden = NO;
            [self.camera stopRecording];
        }
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@",@(self.selectedIndex)]];
    }else {
        
        [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
            if (!error) {
                KB_PublishViewController *vc = [[KB_PublishViewController alloc] init];
                vc.image = image;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } exactSeenImage:NO];
        
    }
}
//获取视频第一帧（用于制作封面）
- (UIImage *)getVideoFirstViewImage:(NSURL *)path {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;

}

@end
