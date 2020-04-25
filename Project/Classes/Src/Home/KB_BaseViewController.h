//
//  KB_BaseViewController.h
//  Project
//
//  Created by hi  kobe on 2020/4/6.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "QDCommonViewController.h"
#import "ZJScrollPageViewDelegate.h"
@class SmallVideoPlayViewController;
@class SmallVideoModel;

NS_ASSUME_NONNULL_BEGIN

@interface KB_BaseViewController : QDCommonViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) NSInteger currentPlayIndex;
@property (nonatomic) BOOL hasMore;

@property (nonatomic, assign) NSInteger rid;

///针对首页的是否自动播放
@property (nonatomic, assign) BOOL isAutoPlay;
@end

NS_ASSUME_NONNULL_END
