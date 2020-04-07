#import <Foundation/Foundation.h>

#define User_Center [UserCenter sharedInstance]

/// 用户中心数据
@interface UserCenter : NSObject <NSCoding>
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *pass;
@property (nonatomic, strong) NSString *authorization;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *token;
@property (nonatomic , strong) NSNumber *bindWx;
@property (nonatomic , strong) NSNumber *bindQq;
@property (nonatomic) BOOL isLogining;
@property(nonatomic, copy) NSString *balance;
+ (instancetype)sharedInstance;
+ (BOOL)checkIsLogin;
+ (void)checkIsLoginState:(void(^)(void))success;
+ (void)clearUserCenter;
+(void)resetUserCenterWithDictionary:(NSDictionary *)dict;
+ (void)save;
@end

