//
//  KB_MineHeaderView.h
//  Project
//
//  Created by hi  kobe on 2020/4/8.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationModel.h"

NS_ASSUME_NONNULL_BEGIN

#define kMineHeaderHeight (SCREEN_WIDTH * 375.0f / 345.0f)
#define kMineBgImgHeight  (SCREEN_WIDTH * 110.0f / 345.0f)

@interface KB_MineHeaderView : UIView
@property (nonatomic, strong) InformationModel *model;
- (void)scrollViewDidScroll:(CGFloat)offsetY;

@end

NS_ASSUME_NONNULL_END
