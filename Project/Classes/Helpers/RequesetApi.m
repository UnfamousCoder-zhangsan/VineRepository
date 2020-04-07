#import "RequesetApi.h"
#import "LoginVC.h"
#import <AFNetworking/AFNetworking.h>
#ifdef DEBUG
static NSString* kAPiHost = @"http://imwork.tpddns.cn:38765";

#else
static NSString* kAPiHost = @"http://imwork.tpddns.cn:38765";
#endif

static NSString* kAPiPath = @"api";
static NSString* kAPkPath = @"apk";
static NSString* const kLoginUrl = @"auth/token";
@implementation ApiResponseModel

@end
@implementation RequestObject
- (instancetype)initWithRequestURL:(NSString *)url params:(NSDictionary *)dict completedBlock:(ApiCompletedBlock)completed {
    self = [super init];
    if (self) {
        self.requestURL = url;
        self.requestParams = dict;
        self.completedBlock = completed;
    }
    return self;
}
@end
static NSMutableArray <RequestObject *> *timeoutRequestMArr;
@implementation RequesetApi


+ (void)requestApiWithParams:(NSDictionary *)params andRequestUrl:(NSString *)url completedBlock:(ApiCompletedBlock)block {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"version"] = App_Version;
    [parameters addEntriesFromDictionary:params];
    NSString *URL = [NSString stringWithFormat:@"%@/%@/%@",kAPiHost, kAPiPath, url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 10;
    [requestSerializer setValue:User_Center.authorization forHTTPHeaderField:@"Authorization"];
    LQLog(@"%@",[User_Center modelToJSONString]);
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager POST:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [NSDictionary changeType:(NSDictionary*)responseObject];
        ApiResponseModel *model = [ApiResponseModel modelWithJSON:responseObject];
        if (model.status > 0) {
            block ? block(model, YES): nil;
        } else if (model.status == -3 || model.status == -6 || model.status == -8) {
            timeoutRequestMArr = timeoutRequestMArr? : [NSMutableArray array];
            RequestObject *timeoutRequest = [[RequestObject alloc] initWithRequestURL:url params:params completedBlock:block];
            [timeoutRequestMArr addObject:timeoutRequest];
            [self requestLoginAutomaticallyWithSuccess:^{
                for (RequestObject *request in timeoutRequestMArr) {
                    [self requestApiWithParams:request.requestParams andRequestUrl:request.requestURL completedBlock:request.completedBlock];
                }
                [timeoutRequestMArr removeAllObjects];
            } failure:^{
                [timeoutRequestMArr removeAllObjects];
                model.msg = @"";
                block ? block(model, NO): nil;
            }];
        } else {
            block ? block(model, NO): nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LQLog(@"Error: %@ ----- API:%@", task.response,url);
        ApiResponseModel *model = [[ApiResponseModel alloc] init];
        model.status = -2000;
        model.msg = @"请求连接失败";
        block ? block(model,NO) : nil;
    }];
    [manager invalidateSessionCancelingTasks:NO];
}

+ (void)requestApiWithBody:(id)body andRequestUrl:(NSString *)url completedBlock:(ApiCompletedBlock)block {

    NSString *URL = [NSString stringWithFormat:@"%@/%@/%@",kAPiHost, kAPiPath, url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 10;
    [requestSerializer setValue:User_Center.authorization forHTTPHeaderField:@"Authorization"];
    LQLog(@"%@",[User_Center modelToJSONString]);
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager POST:URL parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [NSDictionary changeType:(NSDictionary*)responseObject];
        ApiResponseModel *model = [ApiResponseModel modelWithJSON:responseObject];
        if (model.status > 0) {
            block ? block(model, YES): nil;
        } else {
            block ? block(model, NO): nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LQLog(@"Error: %@ ----- API:%@", task.response,url);
        ApiResponseModel *model = [[ApiResponseModel alloc] init];
        model.status = -2000;
        model.msg = @"请求连接失败";
        block ? block(model,NO) : nil;
    }];
    [manager invalidateSessionCancelingTasks:NO];
}

+ (void)requestApkWithParams:(NSDictionary *)params andRequestUrl:(NSString *)url completedBlock:(ApiCompletedBlock)block{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"version"] = App_Version;

    [parameters addEntriesFromDictionary:params];
    NSString *URL = [NSString stringWithFormat:@"%@/%@/%@",kAPiHost, kAPkPath, url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 10;
    [requestSerializer setValue:User_Center.authorization forHTTPHeaderField:@"Authorization"];
    LQLog(@"%@",[User_Center modelToJSONString]);
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager POST:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [NSDictionary changeType:(NSDictionary*)responseObject];
        ApiResponseModel *model = [ApiResponseModel modelWithJSON:responseObject];
        if (model.status > 0) {
            block ? block(model, YES): nil;
        } else if (model.status == -3 || model.status == -6 || model.status == -8) {
            timeoutRequestMArr = timeoutRequestMArr? : [NSMutableArray array];
            RequestObject *timeoutRequest = [[RequestObject alloc] initWithRequestURL:url params:params completedBlock:block];
            [timeoutRequestMArr addObject:timeoutRequest];
            [self requestLoginAutomaticallyWithSuccess:^{
                for (RequestObject *request in timeoutRequestMArr) {
                    [self requestApiWithParams:request.requestParams andRequestUrl:request.requestURL completedBlock:request.completedBlock];
                }
                [timeoutRequestMArr removeAllObjects];
            } failure:^{
                [timeoutRequestMArr removeAllObjects];
                model.msg = @"";
                block ? block(model, NO): nil;
            }];
        } else {
            block ? block(model, NO): nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LQLog(@"Error: %@ ----- APk:%@", task.response,url);
        ApiResponseModel *model = [[ApiResponseModel alloc] init];
        model.status = -2000;
        model.msg = @"请求连接失败";
        block ? block(model,NO) : nil;
    }];
    [manager invalidateSessionCancelingTasks:NO];
}
+ (void)requestGetApiWithParams:(NSDictionary *)params andRequestUrl:(NSString *)url completedBlock:(ApiCompletedBlock)block {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"version"] = App_Version;
    [parameters addEntriesFromDictionary:params];
    NSString *URL = [NSString stringWithFormat:@"%@/%@/%@",kAPiHost,kAPiPath, url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 10;
    [requestSerializer setValue:User_Center.authorization forHTTPHeaderField:@"Authorization"];
    
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];


    [manager GET:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [NSDictionary changeType:(NSDictionary*)responseObject];
        ApiResponseModel *model = [ApiResponseModel modelWithJSON:responseObject];
        if (model.status > 0) {
            block ? block(model, YES): nil;
        } else if (model.status == -3 || model.status == -6 || model.status == -8) {
            timeoutRequestMArr = timeoutRequestMArr? : [NSMutableArray array];
            RequestObject *timeoutRequest = [[RequestObject alloc] initWithRequestURL:url params:params completedBlock:block];
            [timeoutRequestMArr addObject:timeoutRequest];
            [self requestLoginAutomaticallyWithSuccess:^{
                for (RequestObject *request in timeoutRequestMArr) {
                    [self requestGetApiWithParams:request.requestParams andRequestUrl:request.requestURL completedBlock:request.completedBlock];
                }
                [timeoutRequestMArr removeAllObjects];
            } failure:^{
                [timeoutRequestMArr removeAllObjects];
                model.msg = @"";
                block ? block(model, NO): nil;
            }];
        } else {
            block ? block(model, NO): nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LQLog(@"Error: %@ ----- API:%@", task.response,url);
        ApiResponseModel *model = [[ApiResponseModel alloc] init];
        model.status = -2000;
        model.msg = @"请求连接失败";
        block ? block(model,NO) : nil;
    }];
    [manager invalidateSessionCancelingTasks:NO];
}
+ (void)requestGetApkWithParams:(NSDictionary *)params andRequestUrl:(NSString *)url completedBlock:(ApiCompletedBlock)block {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"version"] = App_Version;
    [parameters addEntriesFromDictionary:params];
    NSString *URL = [NSString stringWithFormat:@"%@/%@/%@",kAPiHost,kAPkPath, url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 10;
    [requestSerializer setValue:User_Center.authorization forHTTPHeaderField:@"Authorization"];
    LQLog(@"%@",[User_Center modelToJSONString]);
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];


    [manager GET:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [NSDictionary changeType:(NSDictionary*)responseObject];
        ApiResponseModel *model = [ApiResponseModel modelWithJSON:responseObject];
        if (model.status > 0) {
            block ? block(model, YES): nil;
        } else if (model.status == -3 || model.status == -6 || model.status == -8) {
            timeoutRequestMArr = timeoutRequestMArr? : [NSMutableArray array];
            RequestObject *timeoutRequest = [[RequestObject alloc] initWithRequestURL:url params:params completedBlock:block];
            [timeoutRequestMArr addObject:timeoutRequest];
            [self requestLoginAutomaticallyWithSuccess:^{
                for (RequestObject *request in timeoutRequestMArr) {
                    [self requestGetApiWithParams:request.requestParams andRequestUrl:request.requestURL completedBlock:request.completedBlock];
                }
                [timeoutRequestMArr removeAllObjects];
            } failure:^{
                [timeoutRequestMArr removeAllObjects];
                model.msg = @"";
                block ? block(model, NO): nil;
            }];
        } else {
            block ? block(model, NO): nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LQLog(@"Error: %@ ----- API:%@", task.response,url);
        ApiResponseModel *model = [[ApiResponseModel alloc] init];
        model.status = -2000;
        model.msg = @"请求连接失败";
        block ? block(model,NO) : nil;
    }];
    [manager invalidateSessionCancelingTasks:NO];
}
#pragma mark - 后台自动登录请求
+ (void)requestLoginAutomaticallyWithSuccess:(void(^)(void))success failure:(void(^)(void))failure {
    if (User_Center.ID.length > 0 && User_Center.pass.length > 0) {
        if (!User_Center.isLogining) {
            User_Center.isLogining = YES;
            [self requestApiWithParams:@{@"username": User_Center.ID,
                                         @"password": User_Center.pass,
                                         @"appLicense" : @"ZST"} andRequestUrl:kLoginUrl completedBlock:^(ApiResponseModel *apiResponseModel, BOOL isSuccess) {
                                             if(apiResponseModel) {
                                                 switch (apiResponseModel.status) {
                                                     case 1:
                                                     {
                                                         [UserCenter resetUserCenterWithDictionary:apiResponseModel.data];
                                                         User_Center.authorization = apiResponseModel.data;
                                                         [UserCenter save];
                                                         success ? success() : nil;
                                                         [self saveCookies];
                                                     }
                                                         break;
                                                     default:
                                                     {
                                                         failure ? failure() : nil;
                                                         [PageRoutManeger exitToLoginVC];
                                                     }
                                                         break;
                                                 }
                                             } else {
                                                 failure ? failure() : nil;
                                                 [SVProgressHUD showInfoWithStatus:@"网络好像在开小差~"];
                                             }
                                             [[RACScheduler mainThreadScheduler] afterDelay:5.0 schedule:^{
                                                 User_Center.isLogining = NO;
                                             }];
                                         }];
        } else {
            if (timeoutRequestMArr.count == 1) {
                for (RequestObject *req in timeoutRequestMArr) {
                    [self requestApiWithParams:req.requestParams andRequestUrl:req.requestURL completedBlock:req.completedBlock];
                }
                [timeoutRequestMArr removeAllObjects];
            }
        }
    } else {
        failure ? failure() : nil;
        [UserCenter clearUserCenter];
        [PageRoutManeger gotoLoginVC];
    }
}
#pragma mark - 保存当前已登录状态cookies
+ (void)saveCookies {
    NSString *url = [NSString stringWithFormat:@"%@/%@",kAPiHost, kLoginUrl];
    NSArray <NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:url]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cookie"];
}
#pragma mark - 读取上次登录状态cookies
+ (void)loadCookies {
    if (User_Center.pass.length > 0 && [kUserDefaults objectForKey:@"cookie"]) {
        NSArray <NSHTTPCookie *> *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[kUserDefaults objectForKey:@"cookie"]];
        for (NSHTTPCookie *cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
}
@end
