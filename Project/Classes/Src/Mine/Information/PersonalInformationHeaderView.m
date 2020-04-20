//
//  PersonalInformationHeaderView.m
//  Project
//
//  Created by hi  kobe on 2020/4/12.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "PersonalInformationHeaderView.h"

@interface PersonalInformationHeaderView()<UINavigationControllerDelegate,QMUIImagePickerViewControllerDelegate,QMUIAlbumViewControllerDelegate,QMUIImagePreviewViewDelegate>
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
    
    //点击了更换头像
    [UtilsHelper showActionSheetWithMessage:@"选择方式" view:^{
        //浏览大图
        [self handleImageBrowseEvent];
    } camera:^{
        //拍照
        
    } album:^{
        //相册
        if ([QMUIAssetsManager authorizationStatus] != QMUIAssetAuthorizationStatusNotDetermined) {
            [QMUIAssetsManager requestAuthorization:^(QMUIAssetAuthorizationStatus status) {
                [self presentAlbumViewController];
            }];
        }else{
            [self presentAlbumViewController];
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
//    if (info) {
//        <#statements#>
//    }
    
}

- (void)presentAlbumViewController{
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = QMUIAlbumContentTypeOnlyPhoto;
    albumViewController.title = @"选择头像";
    albumViewController.view.tag = 1084;
    QDNavigationController *navigationController = [[QDNavigationController alloc] initWithRootViewController:albumViewController];
    
    // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿
    [albumViewController pickLastAlbumGroupDirectlyIfCan];
    
    [PageRout_Maneger.currentNaviVC presentViewController:navigationController animated:YES completion:NULL];
    
}
#pragma mark - <QMUIAlbumViewControllerDelegate>
- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = 1;
    imagePickerViewController.view.tag = albumViewController.view.tag;
    imagePickerViewController.allowsMultipleSelection = NO;
    
    return imagePickerViewController;
}

//- (QMUIImagePickerPreviewViewController *)imagePickerPreviewViewControllerForImagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController{
//}

//- (void)imagePickerPreviewViewController:(QDSingleImagePickerPreviewViewController *)imagePickerPreviewViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset {
//    // 储存最近选择了图片的相册，方便下次直接进入该相册
//    [QMUIImagePickerHelper updateLastestAlbumWithAssetsGroup:imagePickerPreviewViewController.QMUIAlbumContentTypeOnlyPhoto ablumContentType:QMUIAlbumContentTypeOnlyPhoto userIdentify:nil];
//    // 显示 loading
//    //[self startLoading];
//    [imageAsset requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGif, BOOL isHEIC) {
//        UIImage *targetImage = nil;
//        if (isGif) {
//            targetImage = [UIImage qmui_animatedImageWithData:imageData];
//        } else {
//            targetImage = [UIImage imageWithData:imageData];
//            if (isHEIC) {
//                // iOS 11 中新增 HEIF/HEVC 格式的资源，直接发送新格式的照片到不支持新格式的设备，照片可能会无法识别，可以先转换为通用的 JPEG 格式再进行使用。
//                // 详细请浏览：https://github.com/Tencent/QMUI_iOS/issues/224
//                targetImage = [UIImage imageWithData:UIImageJPEGRepresentation(targetImage, 1)];
//            }
//        }
//        [self performSelector:@selector(setAvatarWithAvatarImage:) withObject:targetImage afterDelay:1.8];
//    }];
//}
- (void)sendImageWithImagesAssetArray:(NSMutableArray<QMUIAsset *> *)imagesAssetArray {
    //__weak __typeof(self)weakSelf = self;
    
    for (QMUIAsset *asset in imagesAssetArray) {
        [QMUIImagePickerHelper requestImageAssetIfNeeded:asset completion:^(QMUIAssetDownloadStatus downloadStatus, NSError *error) {
            if (downloadStatus == QMUIAssetDownloadStatusDownloading) {
                //[weakSelf startLoadingWithText:@"从 iCloud 加载中"];
            } else if (downloadStatus == QMUIAssetDownloadStatusSucceed) {
               // [weakSelf sendImageWithImagesAssetArrayIfDownloadStatusSucceed:imagesAssetArray];
            } else {
               // [weakSelf showTipLabelWithText:@"iCloud 下载错误，请重新选图"];
            }
        }];
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
