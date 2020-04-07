//
//  UIScrollView+HeaderScaleImage.h
//  YZHeaderScaleImageDemo
//
//  Created by yz on 16/7/29.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HeaderScaleImage)

/**
 *  头部缩放视图图片
 */
@property (nonatomic, strong) UIImage *yz_headerScaleImage;

/*
 指定网络图片
 */
@property (nonatomic, strong) NSURL *yz_headerScaleImageURL;

/**
 *  头部缩放视图图片高度
 */
@property (nonatomic, assign) CGFloat yz_headerScaleImageHeight;

/*!
 扩展：上滑时添加视觉差效果 reyzhang
 */
@property (nonatomic,assign) BOOL yz_isConverAnimation;



/*!
 解决scrollview提前释放导致crash的问题
 在外部控制器的dealloc中调用 reyzhang
 */
- (void)removeHeaderScaleImageObserver;

@end
