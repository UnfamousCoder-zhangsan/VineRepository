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
@interface KB_PublishCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, copy) TextViewBlock textViewBlock;
@end

NS_ASSUME_NONNULL_END
