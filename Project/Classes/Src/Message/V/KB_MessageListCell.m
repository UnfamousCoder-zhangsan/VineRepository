//
//  KB_MessageListCell.m
//  Project
//
//  Created by hikobe on 2020/5/19.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_MessageListCell.h"

@interface KB_MessageListCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation KB_MessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MessageListModel *)model{
    _model = model;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.headerUrl] placeholderImage:UIImageMake(@"")];
    self.nameLabel.text = model.userName;
    self.commentLabel.text = model.comment;
    self.typeLabel.text = model.type;
    NSString *timeStr = [NSString stringWithFormat:@"%@",@(model.time)];
    self.timeLabel.text = [timeStr dateStringUseWeChatFormatSinceNow];
}

@end
