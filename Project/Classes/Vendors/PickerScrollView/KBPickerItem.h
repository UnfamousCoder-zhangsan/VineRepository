//
//  KBPickerItem.h
//  Project
//
//  Created by hualv on 2020/4/11.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KBPickerItem : UIView

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGSize originalSize;
@property (nonatomic, assign) BOOL  selected;

/**
 *选中回调
 */
@property (nonatomic, copy) void(^PickerItemSelectedBlock)(NSInteger index);

/**
 *子类重写实现
 */
- (void)changeSizeOfItem;
- (void)backSizeOfItem;

@end

NS_ASSUME_NONNULL_END
