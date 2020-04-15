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
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(kMineBgImgHeight, 0, 0, 0));
        }];
        
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
        _bgImgView.image = [UIImage imageNamed:@"guide_header"];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.clipsToBounds = YES;
    }
    return _bgImgView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[NSBundle mainBundle] loadNibNamed:@"KB_MineInformationView" owner:nil options:nil].firstObject;
        _contentView.backgroundColor = UIColorMakeWithHex(@"#222222");
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
