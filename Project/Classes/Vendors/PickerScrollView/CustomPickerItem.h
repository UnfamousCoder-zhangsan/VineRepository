//
//  CustomPickerItem.h
//  Project
//
//  Created by hualv on 2020/4/11.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KBPickerItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomPickerItem : KBPickerItem
/// 自定义横向滑动内容
@property (nonatomic, strong) UILabel *itemTitle;
@property (nonatomic, strong) NSString *title;

///  设置title颜色 (默认颜色黑色)
- (void)setItemTitleWith:(nullable UIColor *)color;
@end

NS_ASSUME_NONNULL_END
