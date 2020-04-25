//
//  SmallVideoPlayViewController.h
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2019/1/5.
//  Copyright © 2019年 duoduo. All rights reserved.
//

#import "QDCommonViewController.h"
#import "KB_HomeVideoDetailModel.h"

@class SmallVideoPlayViewController;
@class KB_HomeVideoDetailModel;



NS_ASSUME_NONNULL_BEGIN

@interface SmallVideoPlayViewController : QDCommonViewController

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSMutableArray *modelArray; //模型数据
@property (nonatomic, assign) NSInteger currentPlayIndex;
@property (nonatomic) BOOL hasMore;
@property (nonatomic, assign) NSInteger rid;

@end

NS_ASSUME_NONNULL_END
