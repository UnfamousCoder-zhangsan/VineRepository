//
//  KB_BaseTableListViewController.h
//  Project
//
//  Created by hualv on 2020/4/21.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "QDCommonTableViewController.h"
@class SmallVideoPlayViewController;
@class SmallVideoModel;

NS_ASSUME_NONNULL_BEGIN

@interface KB_BaseTableListViewController : QDCommonTableViewController<GKPageListViewDelegate>

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) BOOL  shouldLoadData;

- (void)addHeaderRefresh;

@end

NS_ASSUME_NONNULL_END
