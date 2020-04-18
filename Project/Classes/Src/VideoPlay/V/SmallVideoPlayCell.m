//
//  SmallVideoPlayCell.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2019/1/5.
//  Copyright © 2019年 duoduo. All rights reserved.
//

#import "SmallVideoPlayCell.h"
#import "FavoriteView.h"


@interface SmallVideoPlayCell ()

@property (nonatomic, strong) UIImageView *coverImageView;


@property (nonatomic, strong) UIImageView *share;
@property (nonatomic, strong) UILabel *shareNum;

/// 评论
@property (nonatomic, strong) UIImageView *comment;
@property (nonatomic, strong) UILabel *commentNum;

/// 点赞
@property (nonatomic, strong) FavoriteView *favorite;
@property (nonatomic, strong) UILabel *favoriteNum;

///头像
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIImageView *focus;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *artistLabel;


@end

@implementation SmallVideoPlayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 底部间距
        UIView *bottomView = [[UIView alloc] init];
        [self.contentView addSubview:bottomView];
        bottomView.backgroundColor = [UIColor blackColor];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.with.offset(0);
            make.height.mas_offset(0);
        }];
        
        ///待添加进度条 ？？？
        
        self.coverImageView = [[UIImageView alloc] init];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.coverImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.coverImageView];
        self.imageView.backgroundColor = [UIColor blackColor];
        self.contentView.backgroundColor = [UIColor blackColor];
        [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.with.offset(0);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        self.playerFatherView = [[UIView alloc] init];
        [self.contentView addSubview:self.playerFatherView];
        [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.with.offset(0);
            make.bottom.equalTo(bottomView.mas_top);
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CAGradientLayer *gradientLayer = [CAGradientLayer new];
        
        gradientLayer.frame = CGRectMake(SCREEN_WIDTH - 100 , 0, 100 , SCREEN_HEIGHT);
        //colors存放渐变的颜色的数组
        gradientLayer.colors=@[(__bridge id)RGBA(0, 0, 0, 0.5).CGColor,(__bridge id)RGBA(0, 0, 0, 0.0).CGColor];
//        gradientLayer.locations = @[@0.3, @0.5, @1.0];
        /**
         * 起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
         */
        gradientLayer.startPoint = CGPointMake(1, 0);
        gradientLayer.endPoint = CGPointMake(0, 0);
        //    layer.frame = self.messageLabel.bounds;
        [self.contentView.layer addSublayer:gradientLayer];
        
        
        
        
        //init share、comment、like action view
        _share = [[UIImageView alloc]init];
        _share.contentMode = UIViewContentModeCenter;
        _share.image = [UIImage imageNamed: @"smallVideo_home_share"];
        _share.userInteractionEnabled = YES;
//        _share.tag = kAwemeListLikeShareTag;
//        [_share addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self.contentView addSubview:_share];
        
        _shareNum = [[UILabel alloc]init];
        _shareNum.text = @"其他";
        _shareNum.textColor = [UIColor whiteColor];//ColorWhite;
        _shareNum.font = [UIFont systemFontOfSize:12 ];//SmallFont;
        [self.contentView addSubview:_shareNum];
        _shareNum.layer.shadowColor = [[UIColor blackColor] CGColor];
        _shareNum.layer.shadowOpacity = 0.3;
        _shareNum.layer.shadowOffset = CGSizeMake(0, 1);
        
        _comment = [[UIImageView alloc]init];
        _comment.contentMode = UIViewContentModeCenter;
        _comment.image = [UIImage imageNamed:@"smallVideo_home_comment"];
        _comment.userInteractionEnabled = YES;
//        _comment.tag = kAwemeListLikeCommentTag;
//        [_comment addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self.contentView addSubview:_comment];
        
        _commentNum = [[UILabel alloc]init];
        _commentNum.text = @"0";
        _commentNum.textColor = [UIColor whiteColor];//ColorWhite;
        _commentNum.font = [UIFont systemFontOfSize:12 ];//SmallFont;
        [self.contentView addSubview:_commentNum];
        _commentNum.layer.shadowColor = [[UIColor blackColor] CGColor];
        _commentNum.layer.shadowOpacity = 0.3;
        _commentNum.layer.shadowOffset = CGSizeMake(0, 1);
//        _commentNum.backgroundColor = [UIColor redColor];
        
        _favorite = [FavoriteView new];
        [self.contentView addSubview:_favorite];
        
        _favoriteNum = [[UILabel alloc]init];
        _favoriteNum.text = @"0";
        _favoriteNum.textColor = [UIColor whiteColor];//ColorWhite;
        _favoriteNum.font = [UIFont systemFontOfSize:12 ];//SmallFont;
        [self.contentView addSubview:_favoriteNum];
        _favoriteNum.layer.shadowColor = [[UIColor blackColor] CGColor];
        _favoriteNum.layer.shadowOpacity = 0.3;
        _favoriteNum.layer.shadowOffset = CGSizeMake(0, 1);
        
        _avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [_avatar createBordersWithColor:[UIColor whiteColor] withCornerRadius:25  andWidth:1];
        _avatar.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatar];
        
        _focus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smallVideo_personal_add_little"]];
        _focus.backgroundColor = RGBA(222, 67, 88, 1);
        [_focus createBordersWithColor:[UIColor clearColor] withCornerRadius:12   andWidth:0];
        _focus.layer.masksToBounds = YES;
        _focus.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_focus];
        
        
        
        _artistLabel = [[UILabel alloc] init];
        _artistLabel.textColor = RGBA(255, 255, 255, 1);
        _artistLabel.font = [UIFont systemFontOfSize:17 ];
        _artistLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        _artistLabel.layer.shadowOpacity = 0.3;
        _artistLabel.layer.shadowOffset = CGSizeMake(0, 1);
        [self.contentView addSubview:_artistLabel];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = RGBA(255, 255, 255, 1);;//RGBA(165, 165, 165, 1);
        _nameLabel.font = [UIFont systemFontOfSize:12 ];
        _nameLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        _nameLabel.layer.shadowOpacity = 0.3;
        _nameLabel.layer.shadowOffset = CGSizeMake(0, 1);
        [self.contentView addSubview:_nameLabel];
        
        @weakify(self);
        _favorite.clickBlock = ^(BOOL isChoose) {
            @strongify(self);
            [self favoriteOrDelVideo:isChoose];
        };
        [_avatar whenTapped:^{
            @strongify(self);
            [self pushToPersonalMessageVC];
        }];
        [_focus whenTapped:^{
            @strongify(self);
            [self addConcern];
        }];
        [_share whenTapped:^{
            @strongify(self);
            [self shareVideo];
        }];
        [_comment whenTapped:^{
            @strongify(self);
            [self commentVidieo];
        }];
        
        [_share mas_makeConstraints:^(MASConstraintMaker *make) {
            if(IS_NOTCHED_SCREEN) {
                make.bottom.with.offset(-150);
            } else {
                make.bottom.with.offset(-135 );
            }
            make.right.with.offset(-10 );
            make.width.mas_equalTo(50 );
            make.height.mas_equalTo(45 );
        }];
        [_shareNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.share.mas_bottom);
            make.centerX.equalTo(self.share);
        }];
        [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.share.mas_top).with.offset(-25 );
            make.right.equalTo(self).with.offset(-10 );
            make.width.mas_equalTo(50 );
            make.height.mas_equalTo(45 );
        }];
        [_commentNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.comment.mas_bottom);
            make.centerX.equalTo(self.comment);
        }];
        [_favorite mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.comment.mas_top).with.offset(-25 );
            make.right.equalTo(self).with.offset(-10 );
            make.width.mas_equalTo(50 );
            make.height.mas_equalTo(45 );
        }];
        [_favoriteNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.favorite.mas_bottom);
            make.centerX.equalTo(self.favorite);
        }];
        [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_favorite);
            make.bottom.equalTo(self.favorite.mas_top).with.offset(-35 );
            make.width.height.mas_equalTo(50 );
        }];
        [_focus mas_makeConstraints:^(MASConstraintMaker *make) {
             make.width.height.mas_equalTo(24 );
            make.centerX.equalTo(self.avatar);
            make.centerY.equalTo(_avatar.mas_bottom);
        }];
        [_artistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(15 );
            if(IS_NOTCHED_SCREEN) {
                make.top.equalTo(self.contentView.mas_bottom).with.offset(-(83  - 10 ));
            } else {
                make.top.equalTo(self.contentView.mas_bottom).with.offset(-83 );
            }
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.with.offset(15 );
            make.width.mas_equalTo(SCREEN_WIDTH * 2 / 3);
            make.top.equalTo(_artistLabel.mas_bottom).with.offset(3 );
        }];
        
        [[RACObserve(self, model.comment_num) ignore:nil] subscribeNext:^(NSNumber *x) {
            @strongify(self);
            self.commentNum.text = x.stringValue;
        }];
        [[RACObserve(self, model.score) ignore:nil] subscribeNext:^(NSNumber *x) {
            @strongify(self);
            self.favoriteNum.text = x.stringValue;
        }];
    }
    return self;
}


//- (void)setModel:(SmallVideoModel *)model {
//    _model = model;
//    self.nameLabel.text = model.name;
//    if(model.artist.length) {
//        self.artistLabel.text = [NSString stringWithFormat:@"@%@",model.artist];
//    } else {
//        self.artistLabel.text = @"";
//    }
//
//    if(model.aspect >= 1.4) {
//        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
//    } else {
//        self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
//    }
//
//    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString: model.cover_url]];
//    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"comment_icon_placeholder"]];
//
//    self.focus.hidden = NO;
//    self.favorite.isChoose = NO;
//
//}

- (void)setVideoModel:(KB_HomeVideoDetailModel *)videoModel{
    _videoModel = videoModel;
    self.nameLabel.text = videoModel.videoDesc;
    self.artistLabel.text = [NSString stringWithFormat:@"@%@",videoModel.nickName];
    if ((videoModel.videoHeight / videoModel.videoWidth) >= 1.4) {
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.lotcloudy.com/scetc-show-videos-mini-api-0.0.1-SNAPSHOT/%@",videoModel.coverPath]] placeholderImage:[UIImage imageNamed:@""]];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.lotcloudy.com/scetc-show-videos-mini-api-0.0.1-SNAPSHOT/%@",videoModel.face_image]] placeholderImage:[UIImage imageNamed:@"comment_icon_placeholder"]];
    
      self.focus.hidden = NO;
      self.favorite.isChoose = NO;
}

#pragma mark - Action

//关注
- (void)addConcern {
    
    if([self.delegate respondsToSelector:@selector(handleAddConcerWithVideoModel:)]) {
        [self.delegate handleAddConcerWithVideoModel:self.model];
    }
}

//进入个人主页
- (void)pushToPersonalMessageVC {
//    NSArray *a = self.viewController.navigationController.childViewControllers;
//    if(a.count > 1) {
//        if([a[a.count-2] isMemberOfClass:[UserHomeViewController class]]) {
//            return;
//        }
//    }
//    if([self.delegate respondsToSelector:@selector(handleClickPersonIcon:)]) {
//        [self.delegate handleClickPersonIcon:self.model];
//    }
}

//收藏视频
- (void)favoriteOrDelVideo:(BOOL)choose {
    if([self.delegate respondsToSelector:@selector(handleFavoriteVdieoModel:)] && choose) {
        [self.delegate handleFavoriteVdieoModel:self.model ];
    } else if([self.delegate respondsToSelector:@selector(handleDeleteFavoriteVdieoModel:)] && !choose) {
        [self.delegate handleDeleteFavoriteVdieoModel:self.model];
    }
}

//评论
- (void)commentVidieo {
    if([self.delegate respondsToSelector:@selector(handleCommentVidieoModel:)]) {
        [self.delegate handleCommentVidieoModel:self.model];
    }
}

//分享
- (void)shareVideo {
    if([self.delegate respondsToSelector:@selector(handleShareVideoModel:)]) {
        [self.delegate handleShareVideoModel:self.model];
    }
}

//设置铃声
- (void)setRing {
    if([self.delegate respondsToSelector:@selector(handleSetRingVideoModel:)]) {
        [self.delegate handleSetRingVideoModel:self.model];
    }
}

//设置动态壁纸
- (void)setLivePhoto {
    if([self.delegate respondsToSelector:@selector(handleSetRingVideoModel:)]) {
        [self.delegate handleSetLivePhoto:self.model];
    }
}

- (void)dealloc {
    DLog(@"销毁了");
}

@end
