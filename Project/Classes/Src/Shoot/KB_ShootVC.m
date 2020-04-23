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

#define ScreenWith     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight   [UIScreen mainScreen].bounds.size.height


@interface KB_ShootVC () <KBPickerScrollViewDelegate, KBPickerScrollViewDataSource>
@property (nonatomic, strong) LLSimpleCamera *camera;
///打开闪光灯按钮
@property (nonatomic, weak)  IBOutlet QMUIButton * flashOnButton;
///切换前后摄像头
@property (nonatomic, weak) IBOutlet QMUIButton * exchangeCamera;

@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (strong, nonatomic) UIButton *snapButton;
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
        @strongify(self)
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
//- (LLSimpleCamera *)camera{
//    if (!_camera) {
//        _camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh position:LLCameraPositionRear videoEnabled:YES];
//        _camera.fixOrientationAfterCapture = NO;
//    }
//    return _camera;
//}
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


- (IBAction)flashModeEvent:(UIButton *)sender {
    if(self.camera.flash == LLCameraFlashOff) {
         BOOL done = [self.camera updateFlashMode:LLCameraFlashOn];
         if(done) {
             self.flashOnButton.selected = YES;
             self.flashOnButton.tintColor = [UIColor yellowColor];
         }
     }
     else {
         BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];
         if(done) {
             self.flashOnButton.selected = NO;
             self.flashOnButton.tintColor = [UIColor whiteColor];
         }
     }
}

- (IBAction)exchangeCameraEvent:(QMUIButton *)sender {
//    //获取当前相机的方向
//    AVCaptureDevicePosition position = [[self.captureDeviceInput device] position];
//    AVCaptureDevice *newCamera = nil;
//    AVCaptureDeviceInput *newInput = nil;
//
//    //为摄像头转换添加转换动画
//    CATransition *animation = [CATransition animation];
//    //切换速度效果
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.duration = 0.5;
//    animation.subtype = kCATransitionFromLeft;
//    animation.type = kCATransitionFade;
//    if (position == AVCaptureDevicePositionFront) {
//        //前置
//        newCamera = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
//    } else if (position == AVCaptureDevicePositionBack) {
//        newCamera = [self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];
//    }
//    [self.contentView.layer addAnimation:animation forKey:nil];
//    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
//    if (newInput != nil) {
//        [self.captureSession beginConfiguration];
//        //先移除原来的input
//        [self.captureSession removeInput:self.captureDeviceInput];
//        if ([self.captureSession canAddInput:newInput]) {
//            [self.captureSession addInput:newInput];
//            self.captureDeviceInput = newInput;
//        } else {
//            [self.captureSession addInput:self.captureDeviceInput];
//        }
//        [self.captureSession commitConfiguration];
//    }
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
    [self.snapButton addTarget:self action:@selector(clickShootBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapButton];
    [self.snapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(70);
        make.centerX.mas_equalTo(self.view.centerX).offset(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
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
    
    [self.exchangeCamera setImagePosition:QMUIButtonImagePositionTop];
    [self.flashOnButton setImagePosition:QMUIButtonImagePositionTop];

    
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
        [self.snapButton setImage:UIImageMake(@"take_picture") forState:UIControlStateNormal];
    } else {
        [self.snapButton setImage:UIImageMake(@"shoot_normal") forState:UIControlStateNormal];
    }
    self.selectedIndex = index;
    // 选中震动反馈
    UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [impactLight impactOccurred];
    
}
- (IBAction)clickShootBtn:(UIButton *)sender {
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

@end
