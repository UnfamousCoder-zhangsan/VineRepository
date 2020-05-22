//
//  KB_MineInformationView.h
//  Project
//
//  Created by hi  kobe on 2020/4/14.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KB_MineInformationView : UIView
@property (nonatomic, strong) InformationModel *model;
@property (nonatomic, assign) BOOL  isFollowed;
@end

NS_ASSUME_NONNULL_END
