//
//  BaseView.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import <UIKit/UIKit.h>
#import "BRPickerStyle.h"

typedef void(^BRCancelBlock)(void);
typedef void(^BRResultBlock)(void);

@interface BRBaseView : UIView

/** 选择器标题 */
@property (nonatomic, copy) NSString *title;

/** 是否自动选择，即滚动选择器后就执行结果回调，默认为 NO */
@property (nonatomic, assign) BOOL isAutoSelect;

/** 自定义UI样式（不传或为nil时，是默认样式） */
@property (nonatomic, strong) BRPickerStyle *pickerStyle;

/** 取消选择的回调 */
@property (nonatomic, copy) BRCancelBlock cancelBlock;

/** accessory view for above picker view. default is nil */
@property (nonatomic, strong) UIView *pickerHeaderView;

/** accessory view below picker view. default is nil */
@property (nonatomic, strong) UIView *pickerFooterView;

/** 选择结果的回调（框架内部使用） */
@property (nonatomic, copy) BRResultBlock doneBlock;

/** 弹框视图 */
@property (nonatomic, strong) UIView *alertView;


/// 刷新选择器数据
/// 应用场景：动态更新数据源、动态更新选择的值、选择器类型切换等
- (void)reloadData;

/// 扩展一：添加选择器到指定容器视图上
/// 应用场景：可将中间的滚轮选择器 pickerView 视图（不包含蒙层及标题栏）添加到任何自定义视图上（会自动填满容器视图），也方便自定义更多的弹框样式
/// @param view 容器视图
- (void)addPickerToView:(UIView *)view;

/// 从指定容器视图上移除选择器
/// @param view 容器视图
- (void)removePickerFromView:(UIView *)view;

/// 扩展二：添加自定义视图到选择器（pickerView）上
/// 应用场景：可以添加一些固定的标题、单位等到选择器中间
/// @param customView 自定义视图
- (void)addSubViewToPicker:(UIView *)customView;

/// 扩展三：添加自定义视图到标题栏（titleBarView）上
/// 应用场景：可以添加一些子控件到标题栏
/// @param customView 自定义视图
- (void)addSubViewToTitleBar:(UIView *)customView;


@end
