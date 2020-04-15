//
//  LoginVC.m
//  PublicLawyerChat
//
//  Created by lawchat on 16/5/12.
//  Copyright © 2016 . All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"

@interface LoginVC() <QMUITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextFiled;


@property (weak, nonatomic) IBOutlet UIButton *rememberPassword_btn;

/// 获得验证码倒计时
@property (assign, nonatomic) BOOL runningGettingCodeTimer;
@end

@implementation LoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = UIColorWhite;
    [self initViewData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initViewData
{
    /// 填充已保存用户名密码
    if (User_Center.id.length > 0) {
        _userNameTextField.text = User_Center.id;
    }
    
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
        self.loginBtn.enabled = [signupActive boolValue];
        if ([signupActive boolValue]) {
            self.loginBtn.backgroundColor = UIColorMakeWithHex(@"#33AAFA");
        } else {
            self.loginBtn.backgroundColor = UIColorDisabled;
        }
    }];

    // 登录交互
    [[[[self.loginBtn
        rac_signalForControlEvents:UIControlEventTouchUpInside]
        doNext:^(id x) {
            @strongify(self)
            self.loginBtn.enabled = NO;
            self.loginBtn.backgroundColor = UIColorDisabled;
        }]
        flattenMap:^id(id x) {
            @strongify(self)
            return [self signInSignal];
        }]
        subscribeNext:^(NSNumber *signedIn) {
            @strongify(self)
            self.loginBtn.enabled = YES;
            self.loginBtn.backgroundColor = UIColorMakeWithHex(@"#33AAFA");
            BOOL success = [signedIn boolValue];
            if (success) {
                // 登录成功进入APP
                [PageRoutManeger changeWindowRootToMainVC];
            }
        }];

    [[self.rememberPassword_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * btn) {
        [btn setSelected:!btn.isSelected];
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
        if ([NSString stringWithFormat:@"%@%@", _userNameTextField.text, string].length > 11) {
            return NO;
        }
    }

    if (textField == _passwordTextFiled) {
        if ([NSString stringWithFormat:@"%@%@", _passwordTextFiled.text, string].length > 6) {
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
        [RequesetApi requestAPIWithParams:params andRequestUrl:@"login" completedBlock:^(ApiResponseModel *apiResponseModel, BOOL isSuccess) {
             if (isSuccess) {
                [SVProgressHUD dismiss];
                // 保存用户名密码
                User_Center.username = params[@"username"];
                if (self.rememberPassword_btn.isSelected) {
                    User_Center.pass = params[@"password"];
                }
               
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
- (IBAction)gotoRegisterVC:(id)sender {
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    RegisterVC *registerVC = [SB instantiateViewControllerWithIdentifier:@"RegisterVC"];
    [self.navigationController pushViewController:registerVC animated:YES];
}


@end
