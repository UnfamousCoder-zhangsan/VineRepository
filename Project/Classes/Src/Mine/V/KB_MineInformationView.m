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
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *focusCount;
@property (weak, nonatomic) IBOutlet UILabel *fanCount;


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
    [self.ageBtn setImage:UIImageMake(@"女") forState:UIControlStateNormal];
    self.ageBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    self.eareBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    self.SchoolBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
}
- (IBAction)modifyInforMationEvent:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"编辑资料"]) {
            KB_PersonalInformationVC *vc = [[UIStoryboard storyboardWithName:@"PersonalInformation" bundle:nil] instantiateViewControllerWithIdentifier:@"KB_PersonalInformationVC"];
        vc.model = self.model;
        [PageRout_Maneger.currentNaviVC pushViewController:vc animated:YES];
    } else {
        if (self.isFollowed) {
            //取消关注
            [RequesetApi requestAPIWithParams:nil andRequestUrl:[NSString stringWithFormat:@"user/userUnFollow?userId=%@&fanId=%@",self.model.id,User_Center.id] completedBlock:^(ApiResponseModel *apiResponseModel, BOOL isSuccess) {
                if (isSuccess) {
                    [self.modifyBtn setTitle:@"关注" forState:UIControlStateNormal];
                    self.modifyBtn.backgroundColor = UIColorMakeWithHex(@"#DC143C");
                    self.isFollowed = NO;
                } else {
                    
                }
            }];
        } else {
            //关注
            [RequesetApi requestAPIWithParams:nil andRequestUrl:[NSString stringWithFormat:@"user/userFollow?userId=%@&fanId=%@",self.model.id,User_Center.id] completedBlock:^(ApiResponseModel *apiResponseModel, BOOL isSuccess) {
                if (isSuccess) {
                    [self.modifyBtn setTitle:@"取消关注" forState:UIControlStateNormal];
                    self.modifyBtn.backgroundColor = UIColorMakeWithHex(@"#777777");
                    self.isFollowed = YES;
                } else {
                    
                }
            }];
        }
    }
}

- (void)setModel:(InformationModel *)model{
    _model = model;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@%@",kAddressUrl,model.faceImage]] placeholderImage:nil];
    self.nameLabel.text = model.nickname;
    self.countLabel.text = model.id;
    if ([model.id isEqualToString:User_Center.id]) {
        [self.modifyBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
        self.modifyBtn.backgroundColor = UIColorMakeWithHex(@"#777777");
    } else {
        
        if (self.isFollowed) {
            [self.modifyBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            self.modifyBtn.backgroundColor = UIColorMakeWithHex(@"#777777");
        } else {
            [self.modifyBtn setTitle:@"关注" forState:UIControlStateNormal];
            self.modifyBtn.backgroundColor = UIColorMakeWithHex(@"#DC143C");
        }
    }
    self.likeCount.text = [NSString stringWithFormat:@"%@获赞",@(model.receiveLikeCounts)];
    self.focusCount.text = [NSString stringWithFormat:@"%@关注",@(model.followCounts)];
    self.fanCount.text = [NSString stringWithFormat:@"%@粉丝",@(model.fansCounts)];
}
@end
