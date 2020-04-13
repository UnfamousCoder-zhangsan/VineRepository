//
//  KB_MineHeaderView.m
//  Project
//
//  Created by hi  kobe on 2020/4/8.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_MineHeaderView.h"
#import "KB_MineInformationView.h"

@interface KB_MineHeaderView()
@property (nonatomic, assign) CGRect        bgImgFrame;
@property (nonatomic, strong) UIImageView   *bgImgView;

@property (nonatomic, strong) KB_MineInformationView        *contentView;
@property (nonatomic, strong) UIImageView   *iconImgView;
@property (nonatomic, strong) UIView   *InformationView;

///name
@property (nonatomic, strong) UILabel *nameLabel;
///count
@property (nonatomic, strong) UILabel *countLabel;
///横线
@property (nonatomic, strong) UIView  *lineView;

///简介
@property (nonatomic, strong) UITextView *IntroductionTextView;
///年龄
@property (nonatomic, strong) QMUIButton *yearBtn;
///地区
@property (nonatomic, strong) QMUIButton *areaBtn;
///学校
@property (nonatomic, strong) QMUIButton *schoolBtn;

/// 获赞
@property (nonatomic, strong) UILabel *praised;
/// 关注
@property (nonatomic, strong) UILabel *attention;
/// 粉丝
@property (nonatomic, strong) UILabel *fan;



@end

@implementation KB_MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgImgView];
        
        [self addSubview:self.contentView];
        //[self.contentView addSubview:self.iconImgView];
        
        self.bgImgFrame = CGRectMake(0, 0, frame.size.width, kMineBgImgHeight);
        self.bgImgView.frame = self.bgImgFrame;
        
        
        
//        self.IntroductionTextView.text = @"测试点 \n 加点东西\n 还有一点展示 👍";
//        self.IntroductionTextView.textColor = UIColorMakeWithHex(@"#FFFFFF");
//        [self.InformationView addSubview:self.IntroductionTextView];
//
//        [self.yearBtn setTitle:@"120岁" forState:UIControlStateNormal];
//        [self.InformationView addSubview:self.yearBtn];
//
//        [self.areaBtn setTitle:@"四川.成都" forState:UIControlStateNormal];
//        [self.InformationView addSubview:self.areaBtn];
//
//        self.praised.text = @"1002获赞";
//        self.praised.textColor = UIColorMakeWithHex(@"#FFFFFF");
//        [self.InformationView addSubview:self.praised];
//
//        self.attention.text = @"100关注";
//        self.attention.textColor = UIColorMakeWithHex(@"#FFFFFF");
//        [self.InformationView addSubview:self.attention];
//
//        self.fan.text = @"233粉丝";
//        self.fan.textColor = UIColorMakeWithHex(@"#FFFFFF");
//        [self.InformationView addSubview:self.fan];
//
//        
//        [self.schoolBtn setTitle:@"电子科技大学成都学院" forState:UIControlStateNormal];
//        [self.InformationView addSubview:self.schoolBtn];
        
//        [self.contentView addSubview:self.InformationView];
//
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(kMineBgImgHeight, 0, 0, 0));
        }];
//
//        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).offset(10.0f);
//            make.top.equalTo(self.contentView).offset(-15.0f);
//            make.width.height.mas_equalTo(96.0f);
//        }];
//
//        [self.InformationView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.iconImgView.mas_bottom);
//            make.left.right.bottom.equalTo(self);
//        }];
//
//        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.InformationView.mas_left).offset(15);
//            make.top.mas_equalTo(self.InformationView.mas_top).offset(5);
//            make.height.offset(18);
//        }];
//        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.InformationView.mas_left).offset(15);
//            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(-5);
//            make.height.offset(12);
//        }];
//        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.InformationView.mas_left).offset(15);
//            make.right.mas_equalTo(self.InformationView.mas_right).offset(-15);
//            make.top.mas_equalTo(self.countLabel.mas_bottom).offset(-10);
//            make.height.offset(1);
//        }];
        
        
        
    }
    return self;
}

- (void)scrollViewDidScroll:(CGFloat)offsetY {
    CGRect frame = self.bgImgFrame;
    // 上下放大
    frame.size.height -= offsetY;
    frame.origin.y = offsetY;
    
    // 左右放大
    if (offsetY <= 0) {
        frame.size.width = frame.size.height * self.bgImgFrame.size.width / self.bgImgFrame.size.height;
        frame.origin.x   = (self.frame.size.width - frame.size.width) / 2;
    }
    
    self.bgImgView.frame = frame;
}

#pragma mark - 懒加载
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        _bgImgView.image = [UIImage imageNamed:@"404"];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.clipsToBounds = YES;
    }
    return _bgImgView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[NSBundle mainBundle] loadNibNamed:@"KB_MineInformationView" owner:nil options:nil].firstObject;
        //_contentView.backgroundColor = UIColorMakeWithHex(@"#888888");
    }
    return _contentView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"图片加载失败"];
        _iconImgView.contentMode = UIViewContentModeScaleToFill;
        _iconImgView.layer.cornerRadius = 48.0f;
        _iconImgView.layer.masksToBounds = YES;
        _iconImgView.layer.borderColor = UIColorMakeWithHex(@"#222222").CGColor;
        _iconImgView.layer.borderWidth = 3;
    }
    return _iconImgView;
}

- (UIView *)InformationView {
    if (!_InformationView) {
        _InformationView = [[UIView alloc] init];
        _InformationView.backgroundColor = UIColorMakeWithHex(@"#111111");
    }
    return _InformationView;
}
@end
