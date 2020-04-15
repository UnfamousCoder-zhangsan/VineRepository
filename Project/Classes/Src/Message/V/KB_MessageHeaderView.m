//
//  KB_MessageHeaderView.m
//  Project
//
//  Created by hualv on 2020/4/13.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_MessageHeaderView.h"

@interface KB_MessageHeaderView()
@property (weak, nonatomic) IBOutlet QMUIButton *likeBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *commentBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *fanBtn;


@end

@implementation KB_MessageHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.likeBtn setImagePosition:QMUIButtonImagePositionTop];
    [self.likeBtn setSpacingBetweenImageAndTitle:5];
    [self.commentBtn setImagePosition:QMUIButtonImagePositionTop];
    [self.commentBtn setSpacingBetweenImageAndTitle:5];
    [self.fanBtn setImagePosition:QMUIButtonImagePositionTop];
    [self.fanBtn setSpacingBetweenImageAndTitle:5];
}
@end
