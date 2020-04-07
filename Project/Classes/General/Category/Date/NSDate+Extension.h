//
//  NSDate+Extension.h
//  LawChatForLawyer
//
//  Created by Juice on 2017/12/28.
//  Copyright © 2017年 就问律师. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Extension)

/// 判断是否是当天
- (BOOL)isToday;

/// 判断是否是昨天
- (BOOL)isYesterday;

/// 判断是否是同一周
- (BOOL)isSameWeek;

///获取当前时间戳
+ (NSString *)getNowTimestampStringLevelMilliSecond;

/// 时间戳转date
/// @param stampTime 时间戳（10位或13位）字符串
+ (NSDate *)dateWithTimeStamp:(NSString *)stampTime;


@end
