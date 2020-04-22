//
//  PersonalInformationHeaderView.m
//  Project
//
//  Created by hi  kobe on 2020/4/12.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "PersonalInformationHeaderView.h"

@interface PersonalInformationHeaderView()<UINavigationControllerDelegate,QMUIImagePickerViewControllerDelegate,QMUIAlbumViewControllerDelegate,QMUIImagePreviewViewDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
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
            [self authorizationPresentAlbumViewController];
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

#pragma mark - 选择图片
- (void)authorizationPresentAlbumViewController
{
    // 请求访问照片库的权限，在 iOS 8 或以上版本中可以利用这个方法弹出 Alert 询问用户是否授权
    if ([QMUIAssetsManager authorizationStatus] == QMUIAssetAuthorizationStatusNotDetermined) {
        __weak __typeof(self) weakSelf = self;
        [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf presentAlbumViewController];
            });
        }];
    } else {
        [self presentAlbumViewController];
    }
}


- (void)presentAlbumViewController{
    // 创建一个 QMUIAlbumViewController 实例用于呈现相薄列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = QMUIAlbumContentTypeOnlyPhoto; //只读取图片
    albumViewController.title = @"选择图片";
    QMUINavigationController *navigationController = [[QMUINavigationController alloc] initWithRootViewController:albumViewController];

     // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿

     QMUIAssetsGroup *assetsGroup = [QMUIImagePickerHelper assetsGroupOfLastPickerAlbumWithUserIdentify:nil];
     if (assetsGroup) {
         QMUIImagePickerViewController *imagePickerViewController = [self imagePickerViewControllerForAlbumViewController:albumViewController];

         [imagePickerViewController refreshWithAssetsGroup:assetsGroup];
         imagePickerViewController.title = [assetsGroup name];
         [navigationController pushViewController:imagePickerViewController animated:NO];
     }

     [PageRout_Maneger.currentNaviVC presentViewController:navigationController animated:YES completion:NULL];
    
}
#pragma mark - <QMUIAlbumViewControllerDelegate>
- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = 1;
    imagePickerViewController.allowsMultipleSelection = NO; //不允许多选图片
    
    return imagePickerViewController;
}

#pragma mark - <QMUIImagePickerViewControllerDelegate>

- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray
{
    // 储存最近选择了图片的相册，方便下次直接进入该相册
    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerViewController.assetsGroup ablumContentType:QMUIAlbumContentTypeOnlyPhoto userIdentify:nil];
    @weakify(self)
    [imagesAssetArray enumerateObjectsUsingBlock:^(QMUIAsset *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        @strongify(self)
        UIImage *image = obj.originImage;
        if (!image) {
            image = obj.previewImage;
        }
        if (image) {
           // 设置头像
            self.headerImage.image = image;
        }
    }];
}

#pragma mark -imagePicker delegate - 用于拍照 获取回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    // 当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        // 关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        // 先把图片转成NSData
        UIImage *editImg = [info objectForKey:UIImagePickerControllerOriginalImage];

        // 设置头像
        self.headerImage.image = editImg;
    }
}
#pragma mark - 设置头像 - 
- (void)setAvatarWithAvatarImage:(UIImage *)avatarImage {
   
    self.headerImage.image = avatarImage;
}

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
