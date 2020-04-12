//
//  PersonalInformationHeaderView.m
//  Project
//
//  Created by hi  kobe on 2020/4/12.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "PersonalInformationHeaderView.h"
@interface PersonalInformationHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation PersonalInformationHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.headerImage.layer.cornerRadius = 50;
    self.headerImage.layer.masksToBounds = YES;
    // view添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self.backView addGestureRecognizer:tapGesture];
}

- (void)tapEvent:(UITapGestureRecognizer *)gesture
{
    //点击了更换头像
    [UtilsHelper showActionSheetWithMessage:@"选择方式" camera:^{
        //相册
    } album:^{
        // 拍一张
        
    }];
}
@end
