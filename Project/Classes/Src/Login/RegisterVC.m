//
//  RegisterVC.m
//  Project
//
//  Created by hualv on 2020/4/15.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *registerBrn;
@property (weak, nonatomic) IBOutlet UIButton *gotoLoginBtn;


@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.registerBrn.layer.cornerRadius = 5;
    self.gotoLoginBtn.layer.cornerRadius = 5;
    [self initViewData];
}
- (UIImage *)navigationBarBackgroundImage{
    return [UIImage imageWithColor:UIColorMakeWithHex(@"#222222")];
}
- (UIColor *)navigationBarTintColor{
    return UIColorMakeWithHex(@"#FFFFFF");
}
- (void)initViewData
{
    
    _userNameTextField.delegate = self;
    _passwordTextFiled.delegate = self;

    @weakify(self)
    // 用户名输入框信号通道
    RACSignal *validUsernameSignal =
        [self.userNameTextField.rac_textSignal
            map:^id(NSString *text) {
                @strongify(self)
                BOOL isValid = [self isValidUsername:text];
                return @(isValid);
            }];


    // 密码输入框信号通道
    RACSignal *validPasswordSignal =
        [self.passwordTextFiled.rac_textSignal
            map:^id(NSString *text) {
                @strongify(self)
                return @([self isValidPassword:text]);
            }];


    // 聚合用户名-密码 输入框信号通道
    RACSignal *signUpActiveSignal =
        [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal]
                          reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid) {
                              return @([usernameValid boolValue] && [passwordValid boolValue]);
                          }];
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
        @strongify(self)
        self.registerBrn.enabled = [signupActive boolValue];
        if ([signupActive boolValue]) {
            self.registerBrn.backgroundColor = UIColorMakeWithHex(@"#33AAFA");
        } else {
            self.registerBrn.backgroundColor = UIColorDisabled;
        }
    }];

    // 登录交互
    [[[[self.registerBrn
        rac_signalForControlEvents:UIControlEventTouchUpInside]
        doNext:^(id x) {
            @strongify(self)
            self.registerBrn.enabled = NO;
            self.registerBrn.backgroundColor = UIColorDisabled;
        }]
        flattenMap:^id(id x) {
            @strongify(self)
            return [self signInSignal];
        }]
        subscribeNext:^(NSNumber *signedIn) {
            @strongify(self)
            self.registerBrn.enabled = YES;
            self.registerBrn.backgroundColor = UIColorMakeWithHex(@"#33AAFA");
            BOOL success = [signedIn boolValue];
            if (success) {
                // 登录成功进入APP
                [PageRoutManeger changeWindowRootToMainVC];
            }
        }];
}

#pragma mark - 用户名是否有效
- (BOOL)isValidUsername:(NSString *)text
{
    return text.length > 0;
}

#pragma mark - 密码是否有效
- (BOOL)isValidPassword:(NSString *)text
{
    return text.length > 0;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _userNameTextField) {
        if ([NSString stringWithFormat:@"%@%@", _userNameTextField.text, string].length > 20) {
            return NO;
        }
    }

    if (textField == _passwordTextFiled) {
        if ([NSString stringWithFormat:@"%@%@", _passwordTextFiled.text, string].length > 16) {
            return NO;
        }
    }

    return YES;
}

#pragma mark - 登录按钮消息通道
- (RACSignal *)signInSignal
{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"username"] = self.userNameTextField.text;
        params[@"password"] = self.passwordTextFiled.text;
        [SVProgressHUD show];
        [UserCenter clearUserCenter];
        [RequesetApi requestAPIWithParams:params andRequestUrl:@"regist" completedBlock:^(ApiResponseModel *apiResponseModel, BOOL isSuccess) {
             if (isSuccess) {
                [SVProgressHUD dismiss];
                // 保存用户名密码
                User_Center.username = params[@"username"];
                // 用户中心
                [UserCenter resetUserCenterWithDictionary:apiResponseModel.data];
                User_Center.userToken = apiResponseModel.data[@"userToken"];
                [UserCenter save];
                [subscriber sendNext:@(YES)];
                [subscriber sendCompleted];
            } else {
                [SVProgressHUD showErrorWithStatus:apiResponseModel.msg];
                [subscriber sendNext:@(NO)];
                [subscriber sendCompleted];
            }
         }];
        return nil;
    }];
}
- (IBAction)gotoLoginVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
