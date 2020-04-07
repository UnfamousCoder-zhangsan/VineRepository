//
//  SDSelectorCell.m
//  SDPagesSelector
//
//  Created by 宋东昊 on 16/7/15.
//  Copyright © 2016年 songdh. All rights reserved.
//

#import "SDSelectorCell.h"

@interface SDSelectorCell ()
@property (nonatomic, strong) UIButton *titleBtn;
@end

@implementation SDSelectorCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _selectedColor = [UIColor redColor];
        _normalColor = [UIColor whiteColor];
        _selectedFont = _normalFont = [UIFont systemFontOfSize:14];

        
        _titleBtn = [[UIButton alloc]init];
        _titleBtn.backgroundColor = [UIColor clearColor];
        _titleBtn.userInteractionEnabled = NO;
        [_titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 0)];
        [_titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
        
        [self.contentView addSubview:_titleBtn];
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    [_titleBtn setTitle:_title forState:UIControlStateNormal];
    [_titleBtn setTitle:_title forState:UIControlStateSelected];
}

- (void)setNormalImage:(NSString *)normalImage {
    if (normalImage.length > 0) {
        _normalImage = normalImage;
        
        [_titleBtn setImage:[UIImage imageNamed:_normalImage] forState:UIControlStateNormal];
    }
}

-(void)setSelectedImage:(NSString *)selectedImage {
    if (selectedImage.length > 0) {
        _selectedImage = selectedImage;
        [_titleBtn setImage:[UIImage imageNamed:_selectedImage] forState:UIControlStateSelected];
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [_titleBtn setTitleColor:_selectedColor forState:UIControlStateSelected];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [_titleBtn setTitleColor:normalColor forState:UIControlStateNormal] ;
}

-(void)setItemSelected:(BOOL)selected
{
    self.selected = selected;
    [_titleBtn setSelected:selected];
    if (selected) {
        _titleBtn.titleLabel.font = _selectedFont;
        
    }else{
        _titleBtn.titleLabel.font = _normalFont;

    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _titleBtn.frame = self.bounds;
}

@end
