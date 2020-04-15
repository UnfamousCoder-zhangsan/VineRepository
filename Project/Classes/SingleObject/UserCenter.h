#import <Foundation/Foundation.h>

#define User_Center [UserCenter sharedInstance]

/// 用户中心数据
@interface UserCenter : NSObject <NSCoding>
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *pass;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *faceImage;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *fansCounts;
@property (nonatomic, strong) NSString *followCounts;
@property (nonatomic, strong) NSString *receiveLikeCounts;
@property (nonatomic, strong) NSString *userToken;
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

