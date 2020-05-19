//
//  KB_MessageListCell.h
//  Project
//
//  Created by hikobe on 2020/5/19.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KB_MessageListCell : UITableViewCell
@property(nonatomic, strong) MessageListModel *model;
@end

NS_ASSUME_NONNULL_END
