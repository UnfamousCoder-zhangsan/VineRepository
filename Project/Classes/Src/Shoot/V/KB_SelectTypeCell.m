//
//  KB_SelectTypeCell.m
//  Project
//
//  Created by hi  kobe on 2020/5/24.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_SelectTypeCell.h"

@interface KB_SelectTypeCell()
@property (weak, nonatomic) IBOutlet QMUIButton *Comprehensive;
@property (weak, nonatomic) IBOutlet QMUIButton *beautyShot;
@property (weak, nonatomic) IBOutlet QMUIButton *food;

@end

@implementation KB_SelectTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.Comprehensive setImagePosition:QMUIButtonImagePositionLeft];
    self.Comprehensive.spacingBetweenImageAndTitle = 5;
    [self.beautyShot setImagePosition:QMUIButtonImagePositionLeft];
    self.beautyShot.spacingBetweenImageAndTitle = 5;
    [self.food setImagePosition:QMUIButtonImagePositionLeft];
    self.food.spacingBetweenImageAndTitle = 5;
    
}
- (IBAction)ComprehensiveAction:(QMUIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.beautyShot.selected = NO;
        self.food.selected = NO;
        if (self.selectedBlock) {
            self.selectedBlock(@"define");
        }
    }
}
- (IBAction)beautyShotAction:(QMUIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.Comprehensive.selected = NO;
        self.food.selected = NO;
    }
    if (self.selectedBlock) {
        self.selectedBlock(@"dress");
    }
}
- (IBAction)foodAction:(QMUIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.beautyShot.selected = NO;
        self.Comprehensive.selected = NO;
    }
    if (self.selectedBlock) {
        self.selectedBlock(@"food");
    };
}



@end
