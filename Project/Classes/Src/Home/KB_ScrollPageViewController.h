//
//  KB_ScrollPageViewController.h
//  Project
//
//  Created by hi  kobe on 2020/4/24.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "QDCommonViewController.h"
#import "ZJScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface KB_ScrollPageViewController : QDCommonViewController<ZJScrollPageViewChildVcDelegate>
@property (assign, nonatomic) NSInteger  index;
@end

NS_ASSUME_NONNULL_END
