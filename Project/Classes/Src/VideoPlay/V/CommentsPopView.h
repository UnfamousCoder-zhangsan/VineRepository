//
//  CommentsPopView.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KB_HomeVideoDetailModel.h"

@interface CommentsPopView:UIView



- (instancetype)initWithSmallVideoModel:(KB_HomeVideoDetailModel *)smallVideoModel;
- (void)showToView:(UIView *)view;
- (void)dismiss;

@end






