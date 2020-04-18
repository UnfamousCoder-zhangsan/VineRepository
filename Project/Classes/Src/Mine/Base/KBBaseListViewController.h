//
//  KBBaseListViewController.h
//  Project
//
//  Created by hi  kobe on 2020/4/17.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KBBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KBBaseListViewController : KBBaseTableViewController<GKPageListViewDelegate>

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) BOOL  shouldLoadData;

- (void)addHeaderRefresh;

@end

NS_ASSUME_NONNULL_END
