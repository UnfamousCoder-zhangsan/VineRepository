//
//  KB_HomePageViewController.h
//  Project
//
//  Created by hi  kobe on 2020/3/30.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KB_HomePageViewController : QDCommonViewController

// pageScrollView
@property (nonatomic, strong) GKPageScrollView *pageScrollView;
 
@property (nonatomic, strong) UIScrollView     *contentScrollView;

@property (nonatomic, strong) NSArray          *childVCs;

@end

NS_ASSUME_NONNULL_END
