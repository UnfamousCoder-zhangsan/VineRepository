//
//  NSString+Date.m
//  Project
//
//  Created by ChesterLee on 2019/11/15.
//  Copyright © 2019 64365. All rights reserved.
//

#import "NSString+Date.h"

#import "NSDate+Extension.h"

@implementation NSString (Date)

- (NSString *)dateStringWithFormat:(NSString *)format
{
    NSString *timeStamp = self;
    if (timeStamp.length >= 10) {
        timeStamp = [timeStamp substringToIndex:10];
    } else {
        return @"未知时间";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]];
    return [formatter stringFromDate:date];
}

- (NSString *)dateStringUseWeChatFormatSinceNow
{
    NSString *timeStamp = self;
    NSString *result;
    if (timeStamp.length >= 10) {
        timeStamp = [timeStamp substringToIndex:10];
        NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:timeStamp.integerValue];
        // 八小时时区
        NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:timeDate];
        NSDate *mydate = [timeDate dateByAddingTimeInterval:interval];
        NSDate *nowDate = [[NSDate date] dateByAddingTimeInterval:interval];
        // 两个时间间隔
        NSTimeInterval timeInterval = [mydate timeIntervalSinceDate:nowDate];
        timeInterval = -timeInterval;
        // 格式化显示
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]];
        if ([date isToday]) {
            formatter.dateFormat = @"HH:mm";
        } else if ([date isYesterday]) {
            formatter.dateFormat = @"昨天 HH:mm";
        } else if ([date isSameWeek]) {
            formatter.dateFormat = @"EEEE";
        } else {
            formatter.dateFormat = @"yyyy.MM.dd HH:mm";
        }
        result = [formatter stringFromDate:date];
    } else {
        result = @"未知时间";
    }
    return result;
}

@end
