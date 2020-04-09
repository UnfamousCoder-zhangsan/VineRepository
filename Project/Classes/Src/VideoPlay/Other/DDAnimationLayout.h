//
//  DDAnimationLayout.h
//  Project
//
//  Created by hi  kobe on 2020/4/7.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DDAnimationLayout;

@protocol DDAnimationLayoutDelegate <NSObject>

// 动态获取 item 宽度
- (CGSize) DDAnimationLayout:(DDAnimationLayout *)layout atIndexPath:(NSIndexPath *) indexPath;

@end

@interface DDAnimationLayout : UICollectionViewLayout

//水平还是竖直
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic,weak) id <DDAnimationLayoutDelegate> delegate;

//collection距离边界的宽度
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/** 每一列之间的间距 */
@property (nonatomic, assign) CGFloat columnMargin;
/** 每一行之间的间距 */
@property (nonatomic, assign) CGFloat rowMargin;
/** 显示多少行或多少列 */
@property (nonatomic, assign) int rowsOrColumnsCount;

@end

NS_ASSUME_NONNULL_END
