//
//  NSString-Verification.m
//  LawChatForLawyer
//
//  Created by Juice on 2016/12/12.
//  Copyright © 2016年 就问律师. All rights reserved.
//

/**
 *  正则表达式规则：
 *  ^:表示正则开始(可写可不写)
 *  $:表示正则结束(可写可不写)
 *  [3579]:表示值只能为3，5，7，9中的一个
 *  {6,12}:代表6~12位
 *  0-9,a-z:代表0~9之间，a~z之间都可以
 *  [0-9]+ :表示至少有一个或多个0~9之间的数字
 *  *表示匹配零次或多次，相当于{0, }    +表示匹配一次或多次，相当于{1, }    ?表示匹配零次或一次，相当于{0，1}
 */

#import "NSString+Verification.h"

@implementation NSString (Verification)

#pragma mark - 正则匹配手机号
- (BOOL)checkPhoneNumber
{
    //    NSString *pattern = @"^1-[34578]-\\d{9}";
    // 由于虚拟运营商的出现，手机号码第二位限制改为大于等于3
    NSString *pattern = @"^1[2|3|4|5|6|7|8|9][0-9]\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark - 正则匹配用户密码6-18位数字和字母组合
- (BOOL)checkPassword
{
    NSString *pattern = @"^(?![0-9]-$)(?![a-zA-Z]-$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark - 正则匹配用户姓名,20位的中文或英文
- (BOOL)checkUserName
{
    NSString *pattern = @"^[a-zA-Z一-龥]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark - 正则匹配用户姓名2~12位的中文
- (BOOL)checkUserName_ch
{
    NSString *pattern = @"^[\u4e00-\u9fa5]{2,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark - 正则匹配用户身份证号
- (BOOL)checkUserIdCard
{
    if (self.length != 18)
        return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if (![identityStringPredicate evaluateWithObject:self])
        return NO;

    //** 开始进行校验 *//

    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];

    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];

    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for (int i = 0; i < 17; i++) {
        NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum += subStrIndex * idCardWiIndex;
    }

    //计算出校验码所在数组的位置
    NSInteger idCardMod = idCardWiSum % 11;
    //得到最后一位身份证号码
    NSString *idCardLast = [self substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if (idCardMod == 2) {
        if (![idCardLast isEqualToString:@"X"] || [idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    } else {
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if (![idCardLast isEqualToString:[idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 正则匹配邮箱号
- (BOOL)checkUserEmail
{
    NSString *pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark - 正则匹配URL
- (BOOL)checkURL
{
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark - 正则匹配2位小数的金额
- (BOOL)checkMoney
{
    NSString *pattern = @"^[0-9]+(.[0-9]{0,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark - 正则匹配6位验证码
- (BOOL)checkVerificationCode
{
    NSString *pattern = @"^[0-9]{1,6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark - 检测是否是纯数字
- (BOOL)checkPureDigital
{
    //去除字符串中所有数字后如果length大于0则不是纯数字
    //方法二：也可以用正则：^[0-9]*$
    if ([self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length > 0) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 检测字符串中是否含有中文
- (BOOL)checkHasChinese
{
    //Unicode编码中文字符范围在0x4E00~0x9FA5中
    for (int i = 0; i < self.length; i++) {
        unichar ch = [self characterAtIndex:i];
        if (ch >= 0x4E00 && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 判断是否是float类型
- (BOOL)checkPureFloat
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    float val;
    return [scanner scanFloat:&val] && [scanner isAtEnd];
}

#pragma mark - 判断执业证输入是否正确
- (BOOL)checkLawyerLicense
{
    NSString *pattern = @"^[1|2]\\d{4}[1|2][8|9|0|1]\\d{2}[1-9][0-1][\\d]{6}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

- (BOOL)checkPureLetter
{
    NSString *pattern = @"^[a-zA-Z]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

@end
