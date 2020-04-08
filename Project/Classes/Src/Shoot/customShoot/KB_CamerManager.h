//
//  KB_CamerManager.h
//  Project
//
//  Created by hi  kobe on 2020/4/9.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

NS_ASSUME_NONNULL_BEGIN
@protocol KBCamerManagerDelegate <NSObject>

@optional;

@end
@interface KB_CamerManager : NSObject

///代理对象
@property(nonatomic, weak) id<KBCamerManagerDelegate> delegate;
/// 相机初始化
- (instancetype)initWithParentView:(UIView *)view;
/**
 *  拍照
 *
 *  @param block 原图 比例图 裁剪图 （原图是你照相机摄像头能拍出来的大小，比例图是按照原图的比例去缩小一倍，裁剪图是你设置好的摄像范围的图片）
 */
- (void)takePhotoWithImageBlock:(void(^)(UIImage *originImage,UIImage *scaledImage,UIImage *croppedImage))block;
/**
 *  切换前后镜
 *
 *  isFrontCamera (void(^)(NSString *))callback;
 */
- (void)switchCamera:(BOOL)isFrontCamera didFinishChanceBlock:(void(^)(id))block;
/**
 *  切换闪光灯模式
 * （切换顺序：最开始是auto，然后是off，最后是on，一直循环）
 */
- (void)switchFlashMode:(UIButton*)sender;

@end

NS_ASSUME_NONNULL_END
