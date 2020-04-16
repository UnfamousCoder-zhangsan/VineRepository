//
//  PersonalInformationHeaderView.m
//  Project
//
//  Created by hi  kobe on 2020/4/12.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "PersonalInformationHeaderView.h"
@interface PersonalInformationHeaderView()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

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
- (UIImagePickerController *)imagePickerController{
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = true;
    }
    return _imagePickerController;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
//    if (info) {
//        <#statements#>
//    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}
@end
