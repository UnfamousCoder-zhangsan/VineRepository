//
//  UITabBar+badge.h
//  Project
//
//  Created by ChesterLee on 2019/9/28.
//  Copyright © 2019 64365. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar(badge)

/// 显示小红点
/// @param index 下边位置0开始
- (void)showBadgeOnItemIndex:(int)index;
/// 隐藏小红点
/// @param index 小标位置0开始
- (void)hideBadgeOnItemIndex:(int)index;
@end

NS_ASSUME_NONNULL_END
