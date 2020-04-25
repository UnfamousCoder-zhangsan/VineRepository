//
//  KB_NearVideoPlayCell.h
//  Project
//
//  Created by hi  kobe on 2020/4/25.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KB_HomeVideoDetailModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol NearVideoPlayCellDlegate <NSObject>
//关注
- (void)handleAddConcerWithVideoModel:(KB_HomeVideoDetailModel *)model;
//点击头像
- (void)handleClickPersonIcon:(KB_HomeVideoDetailModel *)model;
//收藏视频
- (void)handleFavoriteVdieoModel:(KB_HomeVideoDetailModel *)model;
//取消收藏视频
- (void)handleDeleteFavoriteVdieoModel:(KB_HomeVideoDetailModel *)model;
//评论
- (void)handleCommentVidieoModel:(KB_HomeVideoDetailModel *)model;
//分享
- (void)handleShareVideoModel:(KB_HomeVideoDetailModel *)model;

@end


@interface KB_NearVideoPlayCell : UITableViewCell

@property (nonatomic, strong) KB_HomeVideoDetailModel *videoModel;
@property (nonatomic, strong) UIView *playerFatherView;

@property (nonatomic, weak) id<NearVideoPlayCellDlegate> delegate;
@end

NS_ASSUME_NONNULL_END
