//
//  KB_SettingInformationVC.m
//  Project
//
//  Created by hualv on 2020/4/13.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_SettingInformationVC.h"

@interface KB_SettingInformationVC ()
@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel;

@end

@implementation KB_SettingInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.tableView.backgroundColor = UIColorWhite;
    @weakify(self)
    [self getCacheSize:^(NSString *sizeStr) {
        @strongify(self)
        self.cacheSizeLabel.text = sizeStr;
    }];
    
}

- (UIImage *)navigationBarShadowImage{
    return  [UIImage imageWithColor:UIColorMakeWithHex(@"#FFFFFF")];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    } else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    } else {
        return 20;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 4:
                //
                break;
            case 5:
                //联系客服
                [UtilsHelper callPhone:@"13208196091"];
                break;
            case 6:
            {
                //清除缓存
                [AlertHelper showAlertTitle:@"清除缓存" message:@"你将要清除应用内所有缓存" cancelBlock:^{
                    
                } okBlock:^{
                    [self clearCache:^{
                        _cacheSizeLabel.text = @"0.00M";
                        [SVProgressHUD showSuccessWithStatus:@"清除缓存成功"];
                    }];
                }];
                break;
            }
            default:
                break;
        }
    }else if (indexPath.section == 1) {
        //退出登录
        
    }
}
#pragma mark - 获取本地所有本地文件大小
- (void)getCacheSize:(void (^)(NSString *sizeStr))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 找到缓存所存的路径
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        // 要清除的文件，返回这个路径下的所有文件的数组
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];

        unsigned long long size = 0;
        for (NSString *p in files) {
            NSError *error = nil;

            NSString *cachPath = [path stringByAppendingPathComponent:p];

            NSDictionary<NSString *, id> *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:cachPath error:&error];
            size += [attrs fileSize];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block([NSString stringWithFormat:@"%.2fM", size / 1024.0 / 1024.0]);
        });
    });
}

- (void)clearCache:(void (^)(void))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //找到缓存所存的路径
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //要清除的文件，返回这个路径下的所有文件的数组
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];

        for (NSString *p in files) {
            NSError *error = nil;

            NSString *cachPath = [path stringByAppendingPathComponent:p];

            if ([[NSFileManager defaultManager] fileExistsAtPath:cachPath]) {
                // 删除
                [[NSFileManager defaultManager] removeItemAtPath:cachPath error:&error];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    });
}
//- (void)shareToWeiXin{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//
//    //appicon
//    UIImage *appicon =  [UIImage imageNamed:@"feedback_avatar_lvtu"];
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model.title descr:nil thumImage:appicon];
//    //设置网页地址
//    shareObject.webpageUrl = self.model.link;
//
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error != nil) {
//            [SVProgressHUD showErrorWithStatus:@"分享失败"];
//        }else{
//            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
//        }
//    }];
//}
@end
