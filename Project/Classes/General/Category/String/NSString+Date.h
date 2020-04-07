//
//  NSString+Date.h
//  Project
//
//  Created by ChesterLee on 2019/11/15.
//  Copyright © 2019 64365. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(Date)

/// 时间戳格式化为日期字符串
/// @param format 格式化样式（例如：yyyy-MM-dd）
- (NSString *)dateStringWithFormat:(NSString *)format;

/// 时间戳字符串格式化时间显示规则(仿微信)
- (NSString *)dateStringUseWeChatFormatSinceNow;

@end

NS_ASSUME_NONNULL_END
