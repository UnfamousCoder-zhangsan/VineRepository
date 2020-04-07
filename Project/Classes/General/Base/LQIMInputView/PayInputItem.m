//
//  PayInputItem.m
//  Project
//
//  Created by JW on 2019/8/28.
//  Copyright © 2019 64365. All rights reserved.
//

#import "PayInputItem.h"
@interface PayInputItem()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end
@implementation PayInputItem
-(void)setModel:(InputItemModel *)model{
    _model = model;
    self.imageView.image = [UIImage imageNamed:model.imageName];
    self.label.text = model.title;
}
@end
