//
//  NSString+Format.m
//  Project
//
//  Created by ChesterLee on 2019/11/15.
//  Copyright © 2019 64365. All rights reserved.
//

#import "NSString+Format.h"

@implementation NSString (Format)

- (NSString *)formatMoney
{
    return [self formatDecimalWithCount:2];
}

- (NSString *)formatDecimalWithCount:(NSInteger)decimalCount
{
    NSDecimalNumber *inputNumber = [[NSDecimalNumber alloc] initWithDouble:self.doubleValue];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
        decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                       scale:decimalCount
                            raiseOnExactness:NO
                             raiseOnOverflow:NO
                            raiseOnUnderflow:NO
                         raiseOnDivideByZero:YES];
    NSDecimalNumber *number = [inputNumber decimalNumberByRoundingAccordingToBehavior:roundUp];
    return number.stringValue;
}

- (NSString *)formatPhoneNumber
{
    // 中间四位加*
    if (self.length < 11) {
        return self;
    }
    NSString *centerStr = [self substringWithRange:NSMakeRange(4, 4)];
    NSString *encodeStr = [self qmui_stringByReplacingPattern:centerStr withString:@"****"];
    return encodeStr;
}

@end
