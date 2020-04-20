//
//  KB_ShootVC.m
//  Project
//
//  Created by hi  kobe on 2020/4/6.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_ShootVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AudioToolbox/AudioToolbox.h>

#import "KBPickerScrollerView.h"
#import "CustomPickerItem.h"
#import "KBPickerModel.h"
#import "KB_PublishViewController.h"

#define ScreenWith     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight   [UIScreen mainScreen].bounds.size.height

typedef void(^PropertyChangeBlock) (AVCaptureDevice * captureDevice);

@interface KB_ShootVC () <AVCaptureFileOutputRecordingDelegate, AVCapturePhotoCaptureDelegate,KBPickerScrollViewDelegate, KBPickerScrollViewDataSource>
///负责输入和输出设备之间的数据传输
@property (nonatomic, strong) AVCaptureSession * captureSession;
///负责从AVCaptureDevice获得输入数据
@property (nonatomic, strong) AVCaptureDeviceInput * captureDeviceInput;
///照片输出流
@property (nonatomic, strong) AVCapturePhotoOutput * captureStillImageOutput;
///
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
///视频输出流
@property (nonatomic, strong) AVCaptureMovieFileOutput * captureMovieFileOutPut;
@property (assign,nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;//后台任务标识

///相机拍摄预览图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * captureVideoPreviewLayer;
@property (weak, nonatomic) IBOutlet UIView *contentView;

///打开闪光灯按钮
@property (nonatomic, weak)  IBOutlet QMUIButton * flashOnButton;
///切换前后摄像头
@property (nonatomic, weak) IBOutlet QMUIButton * exchangeCamera;
///聚焦光标
@property (nonatomic, strong) UIImageView * focusCursor;
/// 拍摄
@property (weak, nonatomic) IBOutlet UIButton *shootBtn;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;


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
    [self setupUI];
    [self initCamera];
    [self.captureSession startRunning];
}
//关闭页面
- (IBAction)closeEvent:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (BOOL)preferredNavigationBarHidden
{
    return YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 摄像头初始化
- (void)initCamera{
    //初始化会话
    _captureSession = [[AVCaptureSession alloc] init];
    //设置分辨率
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        _captureSession.sessionPreset=AVCaptureSessionPreset1280x720;
    }
    //获得输入设备 前置
    AVCaptureDevice * captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题。");
        return;
    }
    
    NSError * error = nil;
    
    //添加一个音频输入设备
    AVCaptureDevice * audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    AVCaptureDeviceInput * audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"获得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    _captureMovieFileOutPut = [[AVCaptureMovieFileOutput alloc] init];
    
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    //初始化设备输出对象，用于获得输出数据
    _captureStillImageOutput = [[AVCapturePhotoOutput alloc] init];
    NSDictionary * outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    //输出设置
    ////////????
    [_captureMovieFileOutPut setOutputSettings:outputSettings forConnection:nil];
   // [_captureStillImageOutput setOutputSettings:outputSettings];
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection * captureConnection = [_captureMovieFileOutPut connectionWithMediaType:AVMediaTypeVideo];
        ;
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode= AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    //将设输出添加到会话中
    if ([_captureSession canAddOutput:_captureStillImageOutput]) {
        [_captureSession addOutput:_captureStillImageOutput];
    }
    
    if ([_captureSession canAddOutput:_captureMovieFileOutPut]) {
        [_captureSession addOutput:_captureMovieFileOutPut];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    
    CALayer * layer = self.contentView.layer;
    layer.masksToBounds = YES;
    
    _captureVideoPreviewLayer.frame = layer.bounds;
    //填充模式
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //将视频预览层添加到界面中
    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
    [self setFlashModeButtonStatus];
}

#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"开始录制...");
}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    NSLog(@"视频录制完成.");
    //视频录入完成之后在后台将视频存储到相簿
  //  self.enableRotation=YES;
    UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier=self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier=UIBackgroundTaskInvalid;
    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
        }
        if (lastBackgroundTaskIdentifier!=UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:lastBackgroundTaskIdentifier];
        }
        NSLog(@"成功保存视频到相簿.");
    }];
    
}

#pragma mark - 摄像头相关
//  给输入设备添加通知
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

//屏幕旋转时调整视频预览图层的方向
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    AVCaptureConnection *captureConnection=[self.captureVideoPreviewLayer connection];
    captureConnection.videoOrientation=(AVCaptureVideoOrientation)toInterfaceOrientation;
}
//旋转后重新设置大小
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    _captureVideoPreviewLayer.frame=self.contentView.bounds;
}

//获取指定位置的摄像头
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition) positon{

    NSArray * cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice * camera in cameras) {
        if ([camera position] == positon) {
            return camera;
        }
    }
    return nil;
}

//属性改变操作
- (void)changeDeviceProperty:(PropertyChangeBlock ) propertyChange{
   
    AVCaptureDevice * captureDevice = [self.captureDeviceInput device];
    NSError * error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
      
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
        
    } else {
        
        NSLog(@"设置设备属性过程发生错误，错误信息：%@", error.localizedDescription);
    }
}

//设置闪光灯模式
- (void)setFlashMode:(AVCaptureFlashMode ) flashMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}

//聚焦模式
- (void)setFocusMode:(AVCaptureFocusMode) focusMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

//设置曝光模式
- (void)setExposureMode:(AVCaptureExposureMode) exposureMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}

//设置聚焦点
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
        
    }];
}

//添加点击手势，点按时聚焦
- (void)addGenstureRecognizer{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [self.contentView addGestureRecognizer:tapGesture];
}

- (IBAction)flashModeEvent:(UIButton *)sender {
    AVCaptureDevice * captureDevice = [self.captureDeviceInput device];
    AVCaptureFlashMode flashMode = captureDevice.flashMode;
    if ([captureDevice isFlashAvailable]) {
        self.flashOnButton.hidden  = NO;
        self.flashOnButton.enabled = YES;
        
        switch (flashMode) {
            case AVCaptureFlashModeAuto:
               // self.flashAutoButton.enabled = NO;
                break;
            case AVCaptureFlashModeOn:
              //  self.flashOnButton.enabled = NO;
                break;
            case AVCaptureFlashModeOff:
              //  self.flashOffButton.enabled = NO;
                break;
            default:
                break;
        }
    } else {
       // self.flashAutoButton.hidden = YES;
       // self.flashOnButton.hidden   = YES;
       // self.flashOffButton.hidden  = YES;
    }
}

//设置闪关灯按钮状态
- (void)setFlashModeButtonStatus{
    
    AVCaptureDevice * captureDevice = [self.captureDeviceInput device];
    AVCaptureFlashMode flashMode = captureDevice.flashMode;
    if ([captureDevice isFlashAvailable]) {
        self.flashOnButton.hidden  = NO;
        self.flashOnButton.enabled = YES;
        
        switch (flashMode) {
            case AVCaptureFlashModeAuto:
               // self.flashAutoButton.enabled = NO;
                break;
            case AVCaptureFlashModeOn:
              //  self.flashOnButton.enabled = NO;
                break;
            case AVCaptureFlashModeOff:
              //  self.flashOffButton.enabled = NO;
                break;
            default:
                break;
        }
    } else {
       // self.flashAutoButton.hidden = YES;
       // self.flashOnButton.hidden   = YES;
       // self.flashOffButton.hidden  = YES;
    }
    
}

//设置聚焦光标位置
- (void)setFocusCursorWithPoint:(CGPoint)point{
    
    self.focusCursor.center = point;
    self.focusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursor.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha=0;
    }];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    NSLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    NSLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    NSLog(@"会话发生错误.");
}

#pragma mark - 点击方法
- (void)tapScreen:(UITapGestureRecognizer *) tapGesture{

    CGPoint point = [tapGesture locationInView:self.contentView];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint = [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    point.y +=124;
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

// 打开闪关灯
- (void)clickFlashOnButton:(UIButton *)sender{
    [self setFlashMode:AVCaptureFlashModeOn];
    [self setFlashModeButtonStatus];

}

//关闭闪光灯
- (void)clickFlashOffButton:(UIButton *)sender{
    [self setFlashMode:AVCaptureFlashModeOff];
    [self setFlashModeButtonStatus];

}

- (IBAction)exchangeCameraEvent:(QMUIButton *)sender {
    //获取当前相机的方向
    AVCaptureDevicePosition position = [[self.captureDeviceInput device] position];
    AVCaptureDevice *newCamera = nil;
    AVCaptureDeviceInput *newInput = nil;
    
    //为摄像头转换添加转换动画
    CATransition *animation = [CATransition animation];
    //切换速度效果
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.5;
    animation.subtype = kCATransitionFromLeft;
    animation.type = kCATransitionFade;
    if (position == AVCaptureDevicePositionFront) {
        //前置
        newCamera = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    } else if (position == AVCaptureDevicePositionBack) {
        newCamera = [self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];
    }
    [self.contentView.layer addAnimation:animation forKey:nil];
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    if (newInput != nil) {
        [self.captureSession beginConfiguration];
        //先移除原来的input
        [self.captureSession removeInput:self.captureDeviceInput];
        if ([self.captureSession canAddInput:newInput]) {
            [self.captureSession addInput:newInput];
            self.captureDeviceInput = newInput;
        } else {
            [self.captureSession addInput:self.captureDeviceInput];
        }
        [self.captureSession commitConfiguration];
    }
}

#pragma mark - UI相关和布局
- (void)setupUI{
    
    [self.exchangeCamera setImagePosition:QMUIButtonImagePositionTop];
    [self.flashOnButton setImagePosition:QMUIButtonImagePositionTop];

    
    self.pointLabel.layer.cornerRadius = 5;
    self.pointLabel.layer.masksToBounds = YES;
    self.focusCursor = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.focusCursor.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.4];
    self.focusCursor.layer.cornerRadius = 30;
    self.focusCursor.layer.masksToBounds = YES;
    [self.view addSubview:self.focusCursor];
    
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
        [self.shootBtn setImage:UIImageMake(@"take_picture") forState:UIControlStateNormal];
    } else {
        [self.shootBtn setImage:UIImageMake(@"shoot_normal") forState:UIControlStateNormal];
    }
    self.selectedIndex = index;
    // 选中震动反馈
    UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [impactLight impactOccurred];
    
}
- (IBAction)clickShootBtn:(UIButton *)sender {
    // 拍照
    if (self.selectedIndex != 0) {
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@",@(self.selectedIndex)]];
    }else {
        AVCaptureConnection *captureConnection=[self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
        [captureConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        AVCapturePhotoSettings *outputSetting = [AVCapturePhotoSettings photoSettings];
        [self.captureStillImageOutput capturePhotoWithSettings:outputSetting delegate:self];
    }
}
#pragma mark - AVCapturePhotoCaptureDelegate -
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    
    NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *image = [UIImage imageWithData:data];
    
    KB_PublishViewController *vc =[[KB_PublishViewController alloc] init];
    vc.image = image;
    [self.navigationController pushViewController:vc animated:YES];
    // 停止捕获
    [self.captureSession stopRunning];
    
    //[self.captureSession startRunning];
}

@end
