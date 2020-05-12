//
//  KB_MineCollectionViewCell.m
//  Project
//
//  Created by hi  kobe on 2020/4/18.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_MineCollectionViewCell.h"
@interface KB_MineCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end

@implementation KB_MineCollectionViewCell


- (void)setModel:(KB_HomeVideoDetailModel *)model{
    _model = model;
    [self.faceImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAddressUrl,model.coverPath]] placeholderImage:UIImageMake(@"shoot_album")];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@",@(model.likeCounts)];
}

@end
