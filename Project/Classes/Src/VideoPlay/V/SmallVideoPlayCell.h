//
//  SmallVideoPlayCell.h
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2019/1/5.
//  Copyright © 2019年 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmallVideoModel.h"
#import "KB_HomeVideoDetailModel.h"

@protocol SmallVideoPlayCellDlegate <NSObject>
//关注
- (void)handleAddConcerWithVideoModel:(KB_HomeVideoDetailModel *)smallVideoModel;
//点击头像
- (void)handleClickPersonIcon:(KB_HomeVideoDetailModel *)smallVideoModel;
//收藏视频
- (void)handleFavoriteVdieoModel:(KB_HomeVideoDetailModel *)smallVdeoModel;
//取消收藏视频
- (void)handleDeleteFavoriteVdieoModel:(KB_HomeVideoDetailModel *)smallVdeoModel;
//评论
- (void)handleCommentVidieoModel:(KB_HomeVideoDetailModel *)smallVideoModel;
//分享
- (void)handleShareVideoModel:(KB_HomeVideoDetailModel *)smallVideoModel;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SmallVideoPlayCell : UITableViewCell

@property (nonatomic, strong) SmallVideoModel *model;
@property (nonatomic, strong) KB_HomeVideoDetailModel *videoModel;
@property (nonatomic, strong) UIView *playerFatherView;

@property (nonatomic, weak) id<SmallVideoPlayCellDlegate> delegate;

@end

NS_ASSUME_NONNULL_END
