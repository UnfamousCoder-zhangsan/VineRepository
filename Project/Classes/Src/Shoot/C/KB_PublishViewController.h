//
//  KB_PublishViewController.h
//  Project
//
//  Created by hi  kobe on 2020/4/19.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KB_PublishViewController : QDCommonViewController
/// 照片
@property (nonatomic, strong) UIImage *image;
/// 视频
@property (nonatomic, strong) NSURL   *videoUrl;
@end

NS_ASSUME_NONNULL_END
