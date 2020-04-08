//
//  KB_CamerManager.m
//  Project
//
//  Created by hi  kobe on 2020/4/9.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_CamerManager.h"

#define ScreenWith     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight   [UIScreen mainScreen].bounds.size.height

typedef void(^PropertyChangeBlock) (AVCaptureDevice * captureDevice);

@interface KB_CamerManager () <AVCaptureFileOutputRecordingDelegate> //视频文件输出代理

/// 捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice *device;
/// AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic, strong) AVCaptureDeviceInput *input;
/// 输出图片
@property (nonatomic ,strong) AVCapturePhotoOutput *imageOutput;
/// session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession *session;
/// 图像预览层，实时显示捕获的图像
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previewLayer;
/// 切换前后镜动画结束之后
@property (nonatomic, copy) void (^finishBlock)(void);

@end

@implementation KB_CamerManager
@end
