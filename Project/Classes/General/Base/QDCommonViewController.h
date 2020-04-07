//
//  QDCommonViewController.h
//  qmuidemo
//
//  Created by QMUI Team on 15/4/13.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDThemeProtocol.h"

@interface QDCommonViewController : QMUICommonViewController
/**
 空数据背景显示
 */
-(void)showNoDataEmptyViewWithText:(NSString *_Nullable)text detailText:(NSString *_Nullable)detailText;
/**
 数据获取失败背景显示
 */
-(void)showErrorEmptyViewWithText:(NSString *_Nullable)text acion:(SEL _Nullable)action;

-(CGFloat)navigationBarHeight;
@end
