//
//  KBPickerItem.m
//  Project
//
//  Created by hualv on 2020/4/11.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KBPickerItem.h"

@implementation KBPickerItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTapGesture];
    }
    return self;
}
- (void)addTapGesture
{
    self.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}

- (void)tap
{
    if (self.PickerItemSelectedBlock) {
        self.PickerItemSelectedBlock(self.index);
    }
}

// 留给子类调用
- (void)changeSizeOfItem{}
- (void)backSizeOfItem{}

@end
