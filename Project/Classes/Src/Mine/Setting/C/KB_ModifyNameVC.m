//
//  KB_ModifyNameVC.m
//  Project
//
//  Created by hi  kobe on 2020/4/21.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_ModifyNameVC.h"

@interface KB_ModifyNameVC ()<QMUITextFieldDelegate>
@property (weak, nonatomic) IBOutlet QMUITextField *nickNameField;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation KB_ModifyNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nickNameField.text = self.nameString;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.nickNameField becomeFirstResponder];
    self.saveBtn.alpha = 0.4;
}
- (void)setupNavigationItems{
    [super setupNavigationItems];
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:UIColorMakeWithHex(@"#FFFFFF") forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(saveEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
}

- (void)textField:(QMUITextField *)textField didPreventTextChangeInRange:(NSRange)range replacementString:(NSString *)replacementString{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最大不超过%@个字符",@(self.nickNameField.maximumTextLength)]];
}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    if ([textField.text isEqualToString:self.nameString] || textField.text.length == 0) {
        self.saveBtn.alpha = 0.4;
    } else {
        self.saveBtn.alpha = 1.0;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%@/20",@(textField.text.length)];
}
- (void)saveEvent{
    if (self.saveBtn.alpha < 1.0) {
        return;
    }
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
}

@end
