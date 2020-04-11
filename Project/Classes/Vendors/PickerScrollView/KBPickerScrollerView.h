//
//  KBPickerScrollerView.h
//  Project
//
//  Created by hualv on 2020/4/11.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class KBPickerItem,KBPickerScrollerView;

@protocol KBPickerScrollViewDelegate <NSObject>

@optional
/**
 * 选中 （代理方法-可选）
 * @param menuScrollView KBPickerScrollView
 * @param index  下标
 */
- (void)pickerScrollView:(KBPickerScrollerView *)menuScrollView didSelectedItemAtindex:(NSInteger)index;

/**
 * 改变中心位置item样式
 *@param item KBPickerItem
 */
- (void)itemForIndexChange:(KBPickerItem *)item;

/**
 * 改变非中心位置 item样式
 * @param item KBPickerItem
 */
- (void)itemForIndexBack:(KBPickerItem *)item;

@end

@protocol KBPickerScrollViewDataSource <NSObject>

/**
 * 个数
 * @param pickerScrollView KBPickerScrollView
 * @return 需要展示的item 个数
 */
- (NSInteger)numberOfItemAtPickerScrollView:(KBPickerScrollerView *)pickerScrollView;

/**
 * 用来创建KBPickeritem
 * @param pickerScrollView KBPickerScrollView
 * @param index 位置下标
 * @return KBPickerItem
 */
- (KBPickerItem *)pickerScrollView:(KBPickerScrollerView *)pickerScrollView
                       itemAtIndex:(NSInteger)index;



@end
@interface KBPickerScrollerView : UIView

/// 选中下标
@property (nonatomic, assign) NSInteger selectedIndex;
/// menu宽
@property (nonatomic, assign) CGFloat itemWidth;
/// menu高
@property (nonatomic, assign) CGFloat itemHeight;
/// 第一个itemX值
@property (nonatomic, assign) CGFloat firstItemX;

@property (nonatomic, weak)id<KBPickerScrollViewDelegate> delegate;

@property (nonatomic, weak)id<KBPickerScrollViewDataSource> dataSource;

- (void)reloadData;
- (void)scollToSelectdIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
