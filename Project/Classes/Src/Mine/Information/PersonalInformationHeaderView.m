//
//  PersonalInformationHeaderView.m
//  Project
//
//  Created by hi  kobe on 2020/4/12.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "PersonalInformationHeaderView.h"

@interface PersonalInformationHeaderView()<UINavigationControllerDelegate,QMUIImagePreviewViewDelegate,UIImagePickerControllerDelegate,TOCropViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong) QMUIImagePreviewViewController *imagePreviewViewController;

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
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    //点击了更换头像
    [UtilsHelper showActionSheetWithMessage:@"选择方式" view:^{
        //浏览大图
        [self handleImageBrowseEvent];
    } camera:^{
        //拍照
        if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
            //无权限
            [AlertHelper showAlertMessage:@"请打开相机权限" okBlock:nil];
        } else {
            [self takePhotoUseCamera];
        }
    } album:^{
        //相册
        if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
            //无权限
            [AlertHelper showAlertMessage:@"请打开相册权限" okBlock:nil];
        } else {
            [self showImagePickerWith:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        
    }];
}

#pragma mark - 拍照
- (void)takePhotoUseCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;

    BOOL isCameraAvailable = [UIImagePickerController isSourceTypeAvailable:sourceType];

    if (isCameraAvailable) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = sourceType;

        [PageRout_Maneger.currentNaviVC presentViewController:picker animated:YES completion:nil];
    } else {
        [AlertHelper showAlertMessage:@"无法访问您的照相机！请前往系统设置开启应用的相机访问权限！" okBlock:nil];
    }
}


#pragma mark - 选择图片 -
- (void)showImagePickerWith:(UIImagePickerControllerSourceType)sourceType {
    BOOL isAlbumAvailable = [UIImagePickerController isSourceTypeAvailable:sourceType];
    if (isAlbumAvailable) {
            UIImagePickerController *profilePicker = [[UIImagePickerController alloc] init];
        profilePicker.modalPresentationStyle = UIModalPresentationPopover;
        profilePicker.sourceType = sourceType;
        profilePicker.allowsEditing = NO;
        profilePicker.delegate = self;
        profilePicker.preferredContentSize = CGSizeMake(512, 512);
        [PageRout_Maneger.currentNaviVC presentViewController:profilePicker animated:YES completion:nil];
    } else {
        [AlertHelper showAlertMessage:@"无法访问您的相册！请前往系统设置开启应用的相册访问权限！" okBlock:nil];
    }

}

#pragma mark - <QMUIImagePickerViewControllerDelegate>
- (void)imagePickerViewControllerDidCancel:(QMUIImagePickerViewController *)imagePickerViewController{
    [imagePickerViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -imagePicker delegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *editImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        
        //图片裁剪
        TOCropViewController *cropVC = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleCircular image:editImg];
        cropVC.delegate = self;
        [cropVC.toolbar.cancelTextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cropVC.toolbar.doneTextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // 关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            [PageRout_Maneger.currentNaviVC presentViewController:cropVC animated:YES completion:nil];
        }];
        
    }
}
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    
    //上传图片到服务器，上传成功才dismiss
    [SVProgressHUD showWithStatus:@"上传中"];
    [RequesetApi post:[NSString stringWithFormat:@"/user/uploadFace?userId=%@",User_Center.id] image:image name:@"file" completedBlock:^(ApiResponseModel *apiResponseModel, BOOL isSuccess) {
        if (isSuccess) {
            [cropViewController dismissViewControllerAnimated:YES completion:nil];
            self.headerImage.image = image;
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }
    }];
    
}

#pragma mark - 设置头像 - 
//- (void)setAvatarWithAvatarImage:(UIImage *)avatarImage {
//
//    self.headerImage.image = avatarImage;
//}

#pragma mark - 点击查看大图 -
- (void)handleImageBrowseEvent{
    if (!self.imagePreviewViewController) {
        self.imagePreviewViewController = [[QMUIImagePreviewViewController alloc] init];
        self.imagePreviewViewController.presentingStyle = QMUIImagePreviewViewControllerTransitioningStyleZoom;
        self.imagePreviewViewController.imagePreviewView.delegate = self;
        @weakify(self)
        /// 用于展示动画
        self.imagePreviewViewController.sourceImageView = ^UIView * _Nullable{
            @strongify(self)
            return self.headerImage;
        };
    }
    [PageRout_Maneger.currentNaviVC presentViewController:self.imagePreviewViewController animated:YES completion:nil];
}

#pragma mark - QMUIImagePreviewViewDelegate -
- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView{
    return 1;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index{
    // 模拟网络加载
//    [zoomImageView showLoading];
//    [zoomImageView hideEmptyView];
    zoomImageView.image = self.headerImage.image;
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index{
    return QMUIImagePreviewMediaTypeImage;
}

#pragma mark - QMUIZoomImageViewDelegate -
- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location{
    //退出图片预览
    [PageRout_Maneger.currentNaviVC dismissViewControllerAnimated:YES completion:nil];
}

@end
