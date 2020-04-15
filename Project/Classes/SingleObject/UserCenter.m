#import "UserCenter.h"

static UserCenter *_sharedUserCenter;

@implementation UserCenter

+ (instancetype)sharedInstance
{
    static dispatch_once_t token;

    dispatch_once(&token, ^{
        if ([kUserDefaults objectForKey:@"UserCenter"]) {
            // 获取保存的用户信息
            NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserCenter"];
            _sharedUserCenter = [NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
        }
        if (!_sharedUserCenter) {
            _sharedUserCenter = [[UserCenter alloc] init];
        }
    });

    return _sharedUserCenter;
}

+ (void)resetUserCenterWithDictionary:(NSDictionary *)dict
{
    [User_Center modelSetWithDictionary:dict];

    [UserCenter save];
}

/// 保存用户信息
+ (void)save
{
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:_sharedUserCenter];
    [[NSUserDefaults standardUserDefaults] setObject:archiveData forKey:@"UserCenter"];
}

+ (BOOL)checkIsLogin {
    return User_Center.userToken.length;
}
+ (void)checkIsLoginState:(void(^)(void))success {
    if ([self checkIsLogin]) {
        success?success():nil;
    } else {
        [PageRoutManeger gotoLoginVC];
    }
}

+ (void)clearUserCenter
{
    /**
     *  保留登录名清除其他保存到数据
     */
    NSString *userName = User_Center.username;
    _sharedUserCenter = [[UserCenter alloc] init];
    _sharedUserCenter.username = userName;

    [UserCenter save];
}


MJCodingImplementation
    @end
