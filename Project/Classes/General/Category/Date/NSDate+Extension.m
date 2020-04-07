//
//  NSDate+Extension.m
//  LawChatForLawyer
//
//  Created by Juice on 2017/12/28.
//  Copyright © 2017年 就问律师. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

//是否为今天
- (BOOL)isToday
{
    //now: 2015-09-05 11:23:00
    //self 调用这个方法的对象本身

    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;

    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];

    //2.获得self
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];

    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}

//是否为昨天
- (BOOL)isYesterday
{
    //2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];

    //2014-04-30
    NSDate *selfDate = [self dateWithYMD];

    //获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];

    return cmps.day == 1;
}

//格式化
- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

//是否在同一周
- (BOOL)isSameWeek
{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierISO8601];

    NSInteger nowInteger = [calendar component:NSCalendarUnitWeekOfYear fromDate:[NSDate date]];
    NSInteger nowWeekDay = [calendar component:NSCalendarUnitWeekday fromDate:[NSDate date]];

    NSInteger beforeInteger = -1;
    if (self) {
        beforeInteger = [calendar component:NSCalendarUnitWeekOfYear fromDate:self];
    }

    if (nowInteger == beforeInteger) {
        // 在一周
        return YES;
    } else if (nowInteger - beforeInteger == 1 && nowWeekDay == 1) {
        // 西方一周的第一天从周日开始，所以需要判断当前是否为一周的第一天，如果是，则为同周
        return YES;
    } else {
        return NO;
    }
}

/// 获取当前时间戳（毫秒级）
+ (NSString *)getNowTimestampStringLevelMilliSecond
{
    // 获取当前时间0秒后的时间
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    // *1000 是精确到毫秒，不乘就是精确到秒
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;

    return [NSString stringWithFormat:@"%.0f", time];
}

/// 时间戳字符串转化为rNSDate
+ (NSDate *)dateWithTimeStamp:(NSString *)stampTime
{
    long long time = stampTime.longLongValue;
    if (stampTime.length >= 10) {
        // 毫秒
        time = time / 1000;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return date;
}


@end
