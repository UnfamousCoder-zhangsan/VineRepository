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

typedef NS_ENUM(NSInteger, HomeType)
{
    HomeType_Recommend = 0,//
    HomeType_Focus = 1//
 
};

@interface KB_BaseViewController : QDCommonViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) NSInteger currentPlayIndex;

@property (nonatomic, assign) HomeType homeType;
@end

NS_ASSUME_NONNULL_END
