//
//  LvTuApi.h
//  LvTu
//
//  Created by Chester on 2019/8/15.
//  Copyright © 2019 64365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiResponseModel : NSObject
@property (nonatomic, strong) id data;
@property (nonatomic, strong) id ok;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * msg;
@end
@interface RequestObject : NSObject
@property (strong, nonatomic) NSString *requestURL;
@property (strong, nonatomic) NSDictionary *requestParams;
typedef void(^ApiCompletedBlock)(ApiResponseModel *apiResponseModel, BOOL isSuccess);
@property (copy, nonatomic) ApiCompletedBlock completedBlock;
- (instancetype)initWithRequestURL:(NSString *)url params:(NSDictionary *)dict completedBlock:(ApiCompletedBlock)completed;
@end
@interface RequesetApi : NSObject
#pragma mark - 网络请求
+ (void)requestApiWithParams:(NSDictionary *)params andRequestUrl:(NSString *)url completedBlock:(ApiCompletedBlock)block;
+ (void)requestApiWithBody:(id)body andRequestUrl:(NSString *)url completedBlock:(ApiCompletedBlock)block;
#pragma mark - apk网络请求
+ (void)requestApkWithParams:(NSDictionary *)params andRequestUrl:(NSString *)url completedBlock:(ApiCompletedBlock)block;

+ (void)requestGetApkWithParams:(NSDictionary *)params andRequestUrl:(NSString *)url completedBlock:(ApiCompletedBlock)block ;
#pragma mark - 网络请求
+ (void)requestGetApiWithParams:(NSDictionary *)params andRequestUrl:(NSString *)url completedBlock:(ApiCompletedBlock)block;
#pragma mark - 自动登录
+ (void)requestLoginAutomaticallyWithSuccess:(void(^)(void))success failure:(void(^)(void))failure;

#pragma mark - 小视频网络数据请求 -
/**
 *@param  param参数
 *@param  url网址
 *@param  block网络请求回调
 */
+ (void)requestAPIWithParams:(NSDictionary *)params andRequestUrl:(NSString *)url completedBlock:(ApiCompletedBlock)block;
@end
