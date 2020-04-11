//
//  CustomPickerItem.m
//  Project
//
//  Created by hualv on 2020/4/11.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "CustomPickerItem.h"

@implementation CustomPickerItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    _itemTitle = [[UILabel alloc] init];
    _itemTitle.textAlignment = NSTextAlignmentCenter;
    _itemTitle.font = UIFontBoldMake(16);
    CGFloat itemW = 60;
    CGFloat itemH = 30;
    CGFloat itemX = (self.frame.size.width - itemW) * 0.5;
    CGFloat itemY = (self.frame.size.height - itemH) * 0.5;
    _itemTitle.frame = CGRectMake(itemX, itemY, itemW, itemH);
    [self addSubview:_itemTitle];
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    _itemTitle.text = title;
}
- (void)setItemTitleWith:(UIColor *)color
{
    if (!color) {
        _itemTitle.textColor = [UIColor whiteColor];
    }else{
        _itemTitle.textColor = color;
    }
}
- (void)changeSizeOfItem{
    [self setItemTitleWith:UIColorMakeWithHex(@"#FFFFFF")];
}
- (void)backSizeOfItem{
    [self setItemTitleWith:UIColorMakeWithHex(@"#888888")];
}
@end
