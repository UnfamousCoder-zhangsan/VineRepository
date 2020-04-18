//
//  SmallVideoCell.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2018/12/24.
//  Copyright © 2018年 duoduo. All rights reserved.
//

#import "SmallVideoCell.h"

@interface SmallVideoCell ()

///视频image
@property (nonatomic, strong) UIImageView *videoImageView;
/// 头像
@property (nonatomic, strong) UIImageView *iconImageView;

///用户名
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *gradientBackView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UILabel *commentNumLabel;

@property (nonatomic, strong) UIImageView *concernImageView;
@property (nonatomic, strong) UILabel *concernNumLabel;

///视频内容
@property (nonatomic, strong) UILabel *comment;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) CGFloat bottomHeight;

@end

@implementation SmallVideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setupBaseView];
    }
    return self;
}

- (void)setupBaseView {
    self.contentView.layer.masksToBounds = YES;
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = UIColorMakeWithHex(@"#222222");
    // 底部view
    [self.contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.with.offset(0);
        make.height.mas_equalTo(self.bottomHeight);
    }];
    
    // 评论image
    self.commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SmallVideoComment"]];
    self.commentImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bottomView addSubview:self.commentImageView];
    [self.commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.with.offset(-10 );
        make.width.mas_equalTo(15);
        make.bottom.mas_equalTo(bottomView.mas_top).offset(25);
    }];
    // 评论数
    self.commentNumLabel = [[UILabel alloc] init];
    [bottomView addSubview:self.commentNumLabel];
    self.commentNumLabel.text = @"1234";
    self.commentNumLabel.font = [UIFont systemFontOfSize:10 ];
    self.commentNumLabel.textColor = UIColorMakeWithHex(@"#FFFFFF");
    [self.commentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentImageView);
        make.right.equalTo(self.commentImageView.mas_left).with.offset(-4 );
    }];
   
    
    // 点赞 image
    self.concernImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SmallVideoConcern"]];
    self.concernImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bottomView addSubview:self.concernImageView];
    [self.concernImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commentNumLabel.mas_left).with.offset(-8 );
//        make.centerY.equalTo(bottomView);
        make.width.mas_equalTo(15 );
        make.bottom.mas_equalTo(bottomView.mas_top).offset(25);
    }];
    // 点赞数
    self.concernNumLabel = [[UILabel alloc] init];
    [bottomView addSubview:self.concernNumLabel];
    self.concernNumLabel.text = @"1234";
    self.concernNumLabel.font = [UIFont systemFontOfSize:10 ];
    self.concernNumLabel.textColor = UIColorMakeWithHex(@"#FFFFFF");
    [self.concernNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.concernImageView);
        make.right.equalTo(self.concernImageView.mas_left).with.offset(-4);
    }];
    
    // 封面图片
    self.videoImageView = [[UIImageView alloc] init];
    self.videoImageView.backgroundColor = UIColorMakeWithHex(@"#444444");
    self.videoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.videoImageView.layer.cornerRadius = 5;
    self.videoImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.videoImageView];
    [self.videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.with.offset(0);
        make.bottom.equalTo(bottomView.mas_top).with.offset(0);
    }];
    
    // 头像image
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_icon_placeholder"]];
    self.iconImageView.layer.borderWidth = 1.5;
    self.iconImageView.layer.cornerRadius = 20;
    self.iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.iconImageView];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.iconImageView.backgroundColor = [UIColor blackColor];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_top).offset(5);
        make.left.with.offset(9 );
        make.size.mas_equalTo(CGSizeMake(40,40));
    }];
    @weakify(self)
    [[RACObserve(self, model.status) ignore:nil] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.commentNumLabel.text = x.stringValue;
    }];
    
 
    self.gradientBackView = [[UIView alloc] init];
    [self.videoImageView addSubview:self.gradientBackView];
    [self.gradientBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.with.offset(0);
        make.height.mas_equalTo(30 );
    }];
    
    CAGradientLayer *layer = [CAGradientLayer new];
    self.gradientLayer = layer;
    self.gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, 30 );
    //colors存放渐变的颜色的数组
    layer.colors=@[(__bridge id)RGBA(0, 0, 0, 0.3).CGColor,(__bridge id)RGBA(0, 0, 0, 0.0).CGColor];
    /**
     * 起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
     */
    layer.startPoint = CGPointMake(0.5, 1);
    layer.endPoint = CGPointMake(0.5, 0);
//    layer.frame = self.messageLabel.bounds;
    [self.gradientBackView.layer addSublayer:layer];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.text = @"";
    [bottomView addSubview:self.messageLabel];
    self.messageLabel.font = [UIFont systemFontOfSize:11 ];
    self.messageLabel.textColor = [UIColor whiteColor];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(5 );
        make.bottom.mas_equalTo(self.iconImageView.mas_bottom).offset(0);
    }];
    
    self.comment = [[UILabel alloc] init];
    self.comment.font = UIFontMake(12);
    self.comment.textColor = UIColorMakeWithHex(@"#FFFFFF");
    self.comment.numberOfLines = 0;
    [bottomView addSubview:self.comment];
    [self.comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(5);
        make.right.left.with.offset(0);
        make.bottom.mas_equalTo(bottomView.mas_bottom).offset(0);
    }];
    self.bottomView = bottomView;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
//    CGRect videoImageFrame = self.videoImageView.frame;
//    
//    self.gradientLayer.frame = CGRectMake(0, videoImageFrame.size.height-30, videoImageFrame.size.width, 30);
   
}
- (void)setModel:(KB_HomeVideoDetailModel *)model{
    _model = model;
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.lotcloudy.com/scetc-show-videos-mini-api-0.0.1-SNAPSHOT/%@",model.coverPath]] placeholderImage:[UIImage imageNamed:@""]];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.lotcloudy.com/scetc-show-videos-mini-api-0.0.1-SNAPSHOT/%@",model.face_image]] placeholderImage:[UIImage imageNamed:@""]];
    self.messageLabel.text = model.nickName;
    
    self.concernNumLabel.text = @(model.likeCounts).stringValue;
    self.comment.text = model.videoDesc;
    if (model.videoDesc.length > 0) {
        self.bottomHeight = 40 + [model.videoDesc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH / 2 - 30, CGFLOAT_MAX) font:UIFontMake(14) lineSpacing:5].height;
    } else {
        self.bottomHeight = 40;
    }
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(self.bottomHeight);
    }];
}


@end
