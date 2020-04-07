//
//  NSString+Format.h
//  Project
//
//  Created by ChesterLee on 2019/11/15.
//  Copyright © 2019 64365. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(Format)

/// 金额小数精确位数处理（最多保留两位小数）
- (NSString *)formatMoney;

/// 保留小数几位格式化为字符串
/// @param decimalCount 小数位数
- (NSString *)formatDecimalWithCount:(NSInteger)decimalCount;

/// 对电话号码加*（138****8888）
- (NSString *)formatPhoneNumber;
@end

NS_ASSUME_NONNULL_END
