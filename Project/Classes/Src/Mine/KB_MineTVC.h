//
//  KB_MineTVC.h
//  Project
//
//  Created by hi  kobe on 2020/4/6.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KB_MineTVC : QDCommonViewController
/// 点击头像进入个人主页(非自己主页)
@property (nonatomic, assign) BOOL otherHome;
/// 用户id
@property (nonatomic, strong) NSString *userId;
@end

NS_ASSUME_NONNULL_END
