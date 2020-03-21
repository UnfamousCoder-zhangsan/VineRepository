//
//  BRDatePickerView.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import "BRBaseView.h"
#import "NSDate+BRPickerView.h"

/// 日期选择器格式
typedef NS_ENUM(NSInteger, BRDatePickerMode) {
    // ----- 以下4种是系统自带的样式 -----
    /** 【yyyy-MM-dd】UIDatePickerModeDate（默认） */
    BRDatePickerModeDate,
    /** 【yyyy-MM-dd HH:mm】 UIDatePickerModeDateAndTime */
    BRDatePickerModeDateAndTime,
    /** 【HH:mm】UIDatePickerModeTime */
    BRDatePickerModeTime,
    /** 【HH:mm】UIDatePickerModeCountDownTimer */
    BRDatePickerModeCountDownTimer,
    
    // ----- 以下11种是自定义样式 -----
    /** 【yyyy-MM-dd HH:mm:ss】年月日时分秒 */
    BRDatePickerModeYMDHMS,
    /** 【yyyy-MM-dd HH:mm】年月日时分 */
    BRDatePickerModeYMDHM,
    /** 【yyyy-MM-dd HH】年月日时 */
    BRDatePickerModeYMDH,
    /** 【MM-dd HH:mm】月日时分 */
    BRDatePickerModeMDHM,
    /** 【yyyy-MM-dd】年月日 */
    BRDatePickerModeYMD,
    /** 【yyyy-MM】年月 */
    BRDatePickerModeYM,
    /** 【yyyy】年 */
    BRDatePickerModeY,
    /** 【MM-dd】月日 */
    BRDatePickerModeMD,
    /** 【HH:mm:ss】时分秒 */
    BRDatePickerModeHMS,
    /** 【HH:mm】时分 */
    BRDatePickerModeHM,
    /** 【mm:ss】分秒 */
    BRDatePickerModeMS
};

/// 日期单位显示的位置
typedef NS_ENUM(NSInteger, BRShowUnitType) {
    /** 日期单位显示全部行（默认） */
    BRShowUnitTypeAll,
    /** 日期单位仅显示中间行 */
    BRShowUnitTypeOnlyCenter,
    /** 日期单位不显示 */
    BRShowUnitTypeNone
};

typedef void (^BRDateResultBlock)(NSDate *selectDate, NSString *selectValue);

@interface BRDatePickerView : BRBaseView

/**
 //////////////////////////////////////////////////////////////////////////
 ///
 ///   【用法一】
 ///    特点：灵活，扩展性强（推荐使用！）
 ///
 ////////////////////////////////////////////////////////////////////////*/

/** 日期选择器显示类型 */
@property (nonatomic, assign) BRDatePickerMode pickerMode;

/** 设置选中的时间（推荐使用 selectDate） */
@property (nonatomic, strong) NSDate *selectDate;
@property (nonatomic, copy) NSString *selectValue;

/** 最小时间（可使用 NSDate+BRPickerView 分类中对应的方法进行创建）*/
@property (nonatomic, strong) NSDate *minDate;
/** 最大时间（可使用 NSDate+BRPickerView 分类中对应的方法进行创建）*/
@property (nonatomic, strong) NSDate *maxDate;

/** 选择结果的回调 */
@property (nonatomic, copy) BRDateResultBlock resultBlock;

/** 滚动选择时触发的回调 */
@property (nonatomic, copy) BRDateResultBlock changeBlock;

/** 日期单位显示类型 */
@property (nonatomic, assign) BRShowUnitType showUnitType;

/** 隐藏日期单位，默认为NO */
@property (nonatomic, assign) BOOL hiddenDateUnit BRPickerViewDeprecated("请使用 showUnitType");

/** 是否显示【星期】，默认为 NO  */
@property (nonatomic, assign, getter=isShowWeek) BOOL showWeek;

/** 是否显示【今天】，默认为 NO  */
@property (nonatomic, assign, getter=isShowToday) BOOL showToday;

/** 是否添加【至今】，默认为 NO */
@property (nonatomic, assign, getter=isAddToNow) BOOL addToNow;

/** 设置分的时间间隔，默认为1 */
@property (nonatomic, assign) NSInteger minuteInterval;

/** 设置秒的时间间隔，默认为1 */
@property (nonatomic, assign) NSInteger secondInterval;

/// 初始化时间选择器
/// @param pickerMode  日期选择器显示类型
- (instancetype)initWithPickerMode:(BRDatePickerMode)pickerMode;

/// 弹出选择器视图
- (void)show;

/// 关闭选择器视图
- (void)dismiss;




//================================================= 华丽的分割线 =================================================




/**
 //////////////////////////////////////////////////////////////////////////
 ///
 ///   【用法二】：快捷使用，直接选择下面其中的一个方法进行使用
 ///    特点：快捷，方便
 ///
 ////////////////////////////////////////////////////////////////////////*/

/**
 *  1.显示时间选择器
 *
 *  @param mode             日期显示类型
 *  @param title            选择器标题
 *  @param selectValue      默认选中的时间（默认选中当前时间）
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithMode:(BRDatePickerMode)mode
                         title:(NSString *)title
                   selectValue:(NSString *)selectValue
                   resultBlock:(BRDateResultBlock)resultBlock;

/**
 *  2.显示时间选择器
 *
 *  @param mode             日期显示类型
 *  @param title            选择器标题
 *  @param selectValue      默认选中的时间（默认选中当前时间）
 *  @param isAutoSelect     是否自动选择，即滚动选择器后就执行结果回调，默认为 NO
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithMode:(BRDatePickerMode)mode
                         title:(NSString *)title
                   selectValue:(NSString *)selectValue
                  isAutoSelect:(BOOL)isAutoSelect
                   resultBlock:(BRDateResultBlock)resultBlock;

/**
 *  3.显示时间选择器
 *
 *  @param mode             日期显示类型
 *  @param title            选择器标题
 *  @param selectValue      默认选中的时间（默认选中当前时间）
 *  @param minDate          最小时间（可使用 NSDate+BRPickerView 分类中对应的方法进行创建）
 *  @param maxDate          最大时间（可使用 NSDate+BRPickerView 分类中对应的方法进行创建）
 *  @param isAutoSelect     是否自动选择，即滚动选择器后就执行结果回调，默认为 NO
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithMode:(BRDatePickerMode)mode
                         title:(NSString *)title
                   selectValue:(NSString *)selectValue
                       minDate:(NSDate *)minDate
                       maxDate:(NSDate *)maxDate
                  isAutoSelect:(BOOL)isAutoSelect
                   resultBlock:(BRDateResultBlock)resultBlock;


@end
