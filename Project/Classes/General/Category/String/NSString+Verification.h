//
//  NSString-Verification.h
//  LawChatForLawyer
//
//  Created by Juice on 2016/12/12.
//  Copyright © 2016年 就问律师. All rights reserved.
//  对NSStirng内容格式进行验证

#import <Foundation/Foundation.h>

@interface NSString(Verification)

/// 正则匹配手机号
- (BOOL)checkPhoneNumber;

/// 正则匹配用户密码6-18位数字和字母组合
- (BOOL)checkPassword;

/// 正则匹配用户姓名,20位的中文或英文
- (BOOL)checkUserName;

/// 正则匹配用户姓名,12位的中文
- (BOOL)checkUserName_ch;

/// 正则匹配用户身份证号
- (BOOL)checkUserIdCard;

/// 正则匹配URL
- (BOOL)checkURL;

/// 正则匹配2位小数的金额
- (BOOL)checkMoney;

/// 正则匹配6位验证码
- (BOOL)checkVerificationCode;

/// 检测是否是纯数字
- (BOOL)checkPureDigital;

/// 检测字符串中是否含有中文
- (BOOL)checkHasChinese;

/// 判断执业证输入是否正确
- (BOOL)checkLawyerLicense;

/// 检测是否是纯字母
- (BOOL)checkPureLetter;

/// 正则匹配用户身份证号
- (BOOL)checkUserEmail;

@end
