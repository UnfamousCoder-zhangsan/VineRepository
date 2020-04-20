//
//  KB_PublishCell.h
//  Project
//
//  Created by hi  kobe on 2020/4/19.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TextViewBlock)(NSString *str);
typedef void(^ImageViewTapBlock)(void);
@interface KB_PublishCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;
@property (nonatomic, copy) TextViewBlock textViewBlock;
@property (nonatomic, copy) ImageViewTapBlock imageViewTapBlock;
@end

NS_ASSUME_NONNULL_END
