//
//  UtilsApi.m
//  LawChatForLawyer
//
//  Created by Juice on 2016/12/12.
//  Copyright © 2016年 就问律师. All rights reserved.
//  一些常用方法的封装

#import "UtilsHelper.h"
#import <sys/utsname.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <Contacts/Contacts.h>
#import <CommonCrypto/CommonCrypto.h>
#import "LoginVC.h"
#import "NSDate+Extension.h"

@implementation UtilsHelper

+ (void)showActionSheetWithMessage:(NSString *)message camera:(void (^)(void))cameraBlock album:(void (^)(void))albumBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *_Nonnull action) {
        cameraBlock ? cameraBlock() : nil;
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *_Nonnull action) {
        albumBlock ? albumBlock() : nil;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cameraAction];
    [alertController addAction:albumAction];
    [alertController addAction:cancelAction];
    
    [PageRout_Maneger.currentNaviVC presentViewController:alertController animated:YES completion:nil];
}

+ (void)callPhone:(NSString *)phoneNumber
{
    if (phoneNumber.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"没有手机号码信息"];
        return;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]];
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 10.2) {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:url
                                               options:@{}
                                     completionHandler:nil];
        } else {
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        };
    } else {
        UIImage *img = [[UIImage imageNamed:@"呼叫"] qmui_imageResizedInLimitedSize:CGSizeMake(22, 22) resizingMode:QMUIImageResizingModeScaleToFill];
        img = [img qmui_imageWithTintColor:UIColorMakeWithHex(@"3682ff")];
        [AlertHelper showAlertTitle:@"拨打电话"
                            message:phoneNumber
                         cancelText:@"取消"
                             okText:@"呼叫"
                            okImage:img
                        cancelBlock:nil
                            okBlock:^{
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [[UIApplication sharedApplication] openURL:url
                                                   options:@{}
                                         completionHandler:nil];
            } else {
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            };
        }];
    }
}

/// 拨打客服电话
+ (void)callServicePhone
{
    [self callPhone:kServiceTel];
}


+(NSArray<NSDictionary<NSString*, NSString*> *> *)getEventArr{
    
    NSArray *arr = @[
        @{@"title":@"交通事故",@"code":@"SJLX_JTSG"},
        @{@"title":@"安全检查",@"code":@"SJLX_AQJC"},
        @{@"title":@"安全隐患",@"code":@"SJLX_AQYH"},
        @{@"title":@"施工监管",@"code":@"SJLX_SGJG"},
        @{@"title":@"路产损坏",@"code":@"SJLX_LCSH"},
        @{@"title":@"交安恢复",@"code":@"SJLX_JAHF"},
        @{@"title":@"劝离行人",@"code":@"SJLX_QLXR"},
        @{@"title":@"占道停车",@"code":@"SJLX_ZDTC"},
        @{@"title":@"道路清理",@"code":@"SJLX_DLQL"},
        @{@"title":@"安全宣传",@"code":@"SJLX_AQXC"},
        @{@"title":@"路况上报",@"code":@"SJLX_LKSB"},
        @{@"title":@"冬管",@"code":@"SJLX_DG"},
        @{@"title":@"其他事件",@"code":@"SJLX_QTSJ"},
    ];
    return arr;
}

    
//+(void)getApartmentArr:(void(^)(NSArray<ApartmentListModel*> *apartmentArr))getBlock failure:(void(^)(ApiResponseModel*apiResponseModel))failure {
//   [RequesetApi requestGetApiWithParams:nil andRequestUrl:@"system/dept/get-list" completedBlock:^(ApiResponseModel *apiResponseModel, BOOL isSuccess) {
//         if(isSuccess){
//           NSArray<ApartmentListModel*> *datas =  [NSArray modelArrayWithClass:[ApartmentListModel class] json:apiResponseModel.data];
//             
//             getBlock?getBlock(datas.firstObject.children):nil;
//         } else {
//             failure(apiResponseModel);
//         }
//    }];
//}


@end
