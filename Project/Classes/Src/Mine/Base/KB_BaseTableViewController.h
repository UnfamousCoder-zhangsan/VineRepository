//
//  KB_BaseTableViewController.h
//  Project
//
//  Created by hi  kobe on 2020/4/8.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KB_BaseTableViewController : QDCommonTableViewController<GKPageListViewDelegate>

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) BOOL  shouldLoadData;

- (void)addHeaderRefresh;
@end

NS_ASSUME_NONNULL_END
