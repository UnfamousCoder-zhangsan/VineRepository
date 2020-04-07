//
//  CALayer+XibConfiguration.h
//  LvTu
//
//  Created by Chester on 2019/8/13.
//  Copyright © 2019 64365. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer(XibConfiguration)

/// 边框颜色
@property (nonatomic, assign) UIColor *borderUIColor;

/// 阴影颜色
@property (nonatomic, assign) UIColor *shadowUIColor;
@end

NS_ASSUME_NONNULL_END
