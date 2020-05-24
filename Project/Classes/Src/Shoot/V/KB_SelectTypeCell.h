//
//  KB_SelectTypeCell.h
//  Project
//
//  Created by hi  kobe on 2020/5/24.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectedBlock)(NSString *type);
@interface KB_SelectTypeCell : QMUITableViewCell
@property (nonatomic, copy) SelectedBlock selectedBlock;
@end

NS_ASSUME_NONNULL_END
