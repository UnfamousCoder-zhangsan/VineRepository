//
//  KB_MineInformationView.m
//  Project
//
//  Created by hi  kobe on 2020/4/14.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_MineInformationView.h"
#import "KB_PersonalInformationVC.h"

@interface KB_MineInformationView()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *ageBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *eareBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *SchoolBtn;


@end

@implementation KB_MineInformationView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.headerImage.layer.borderWidth = 5;
    self.headerImage.layer.borderColor = UIColorMakeWithHex(@"#222222").CGColor;
    self.headerImage.layer.cornerRadius = 48;
    self.modifyBtn.layer.cornerRadius = 5;
    self.modifyBtn.layer.masksToBounds = YES;
    [self.ageBtn setImagePosition:QMUIButtonImagePositionLeft];
    [self.ageBtn setImage:UIImageMake(@"单选勾选") forState:UIControlStateNormal];
    self.ageBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    self.eareBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    self.SchoolBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
}
- (IBAction)modifyInforMationEvent:(UIButton *)sender {
    KB_PersonalInformationVC *vc = [[UIStoryboard storyboardWithName:@"PersonalInformation" bundle:nil] instantiateViewControllerWithIdentifier:@"KB_PersonalInformationVC"];
    [PageRout_Maneger.currentNaviVC pushViewController:vc animated:YES];
}


@end
