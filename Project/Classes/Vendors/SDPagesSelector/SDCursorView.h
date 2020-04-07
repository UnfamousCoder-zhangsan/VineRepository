//
//  SDCursorView.h
//  SDPagesSelector
//
//  Created by 宋东昊 on 16/7/15.
//  Copyright © 2016年 songdh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SDCursorViewDelegate <NSObject>

@optional
- (BOOL)shouldSelectItemWithIndex:(NSInteger)index;//点击切换
- (void)sliderChangeItemWithIndex:(NSInteger)index;//滑动切换
@end

@interface SDCursorView : UIView

@property(nonatomic,weak) id<SDCursorViewDelegate> delegate;

/**
 *  底部标识线
 */
@property (nonatomic, strong) UIView *lineView;

/**
 *  当前页面所在的controller，必须赋值
 */
@property (nonatomic, weak) UIViewController *parentViewController;
/**
 *  底部切换页面的容器高度
 */
@property (nonatomic, assign) CGFloat contentViewHeight;

/**
 *  标题和显示的页面，数量必须相等。
 */
@property (nonatomic, copy) NSArray *titles;
/**
 *  正常状态图片
 */
@property (nonatomic, copy) NSArray *normalImages;
/**
 *  选中状态图片
 */
@property (nonatomic, copy) NSArray *selectedImages;


//标题和显示的页面，数量必须相等。 images可有可无
-(void)setTitles:(NSArray *)titles normalImages:(NSArray*)normalImages selectedImages:(NSArray*)selectedImages;

/**
 *  所要添加的viewController的实例。绘制界面时，会将viewController的view添加在scrollView上
 */
@property (nonatomic, copy) NSArray *controllers;

/**
 *  默认分别是 [UIColor redColor],[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *normalColor;

/**
 *  默认都是14号字体
 */
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIFont *normalFont;

/**
 *  当前选中的index。可以设置当前的index
 */
@property (nonatomic, assign) NSInteger currentIndex;
/**
 *  分割线位置调整。总是居中显示  默认(0,3,2,3)
    分割线默认高度为3， left可调整宽度，top可调整高度，bottom可调整lineView的y值
 */
@property (nonatomic, assign) UIEdgeInsets lineEdgeInsets;
/**
 *  添加
 分割线Size 能固定大小   lineEdgeInsets会根据每个item决定当前线的大小
 */
@property (nonatomic, assign) CGSize lineSize;
/**
 *  选择区域调整。默认(0,10,0,10)
 */
@property (nonatomic, assign) UIEdgeInsets cursorEdgeInsets;

/**
 *  内容区是否可以手势滑动
 */
@property(nonatomic, assign) BOOL contentCanScroll;
/**
 *  必须调用此方法来绘制界面
 */
-(void)reloadPages;

-(void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated;


@end
