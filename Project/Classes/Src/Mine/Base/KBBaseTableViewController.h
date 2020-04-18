//
//  KBBaseTableViewController.h
//  Project
//
//  Created by hi  kobe on 2020/4/17.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KBBaseTableViewController : QDCommonViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
