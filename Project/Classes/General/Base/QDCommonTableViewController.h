//
//  QDCommonTableViewController.h
//  qmuidemo
//
//  Created by QMUI Team on 15/4/13.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDThemeProtocol.h"

@interface QDCommonTableViewController : QMUICommonTableViewController
/**
 添加下拉刷新
 */
- (void)addPullRefreshWithBlock:(nullable void (^)(void))block;

/**
 添加上拉加载更多
 
 @param block 上拉加载回调
 */
- (void)addLoadingMoreWithBlock:(nullable void (^)(void))block;

/**
 停止上拉加载更多并隐藏footer
 */
- (void)endRefreshWithFooterHidden;

/**
 空数据背景显示
 */
- (void)showNoDataEmptyViewWithText:(NSString *_Nullable)text detailText:(NSString *_Nullable)detailText;

- (void)showNoDataEmptyViewWithText:(NSString *_Nullable)text detailText:(NSString *_Nullable)detailText buttonTitle:(NSString *)buttonTitle buttonAction:(SEL)action;
/**
 数据获取失败背景显示
 */
- (void)showErrorEmptyViewWithText:(NSString *_Nullable)text acion:(SEL _Nullable)action;


- (void)showNoDataEmptyViewWithText:(NSString *_Nullable)text detailText:(NSString *_Nullable)detailText bottomLabelAttr:(NSMutableAttributedString *)bottomLabelAttr;


- (void)handleGetDataErrorWithHudMsg:(NSString *)hudmsg emptyViewMsg:(NSString *)emptyViewMsg acion:(SEL _Nullable)action;
@end
