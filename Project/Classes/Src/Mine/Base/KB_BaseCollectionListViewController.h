//
//  KB_BaseCollectionListViewController.h
//  Project
//
//  Created by hi  kobe on 2020/4/18.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_BaseCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KB_BaseCollectionListViewController : KB_BaseCollectionViewController<GKPageListViewDelegate>

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) BOOL  shouldLoadData;

@property (nonatomic, strong) NSString *userId;
- (void)addHeaderRefresh;

@end

NS_ASSUME_NONNULL_END
