//
//  UtilsApi.h
//  LawChatForLawyer
//
//  Created by Juice on 2016/12/12.
//  Copyright © 2016年 就问律师. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ApartmentListModel.h"

@interface UtilsHelper : NSObject

/// 选择拍照或从图片选择
/// @param message 标题
/// @param cameraBlock 选择相机回调
/// @param albumBlock 选择相册回调
+ (void)showActionSheetWithMessage:(NSString *)message camera:(void (^)(void))cameraBlock album:(void (^)(void))albumBlock;


/// 拨打电话
/// @param phoneNumber 电话号
+ (void)callPhone:(NSString *)phoneNumber;

/// 拨打客服电话
+ (void)callServicePhone;
///获取事件类型
+(NSArray<NSDictionary<NSString*, NSString*> *> *)getEventArr;
///获取公司数据
//+(void)getApartmentArr:(void(^)(NSArray<ApartmentListModel*> *apartmentArr))getBlock failure:(void(^)(ApiResponseModel*apiResponseModel))failure;


@end
