//
//  KB_ModifyIntroductionVC.m
//  Project
//
//  Created by hi  kobe on 2020/4/21.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_ModifyIntroductionVC.h"

@interface KB_ModifyIntroductionVC ()<QMUITextViewDelegate>
@property (weak, nonatomic) IBOutlet QMUITextView *textView;

@end

@implementation KB_ModifyIntroductionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupNavigationItems{
    [super setupNavigationItems];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"保存" target:self action:@selector(saveEvent)];
}
- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最大不超过%@个字符",@(self.textView.maximumTextLength)]];
}
- (void)textViewDidChange:(UITextView *)textView{
    CGRect textViewFrame = textView.frame;
    CGSize textSize = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), 120.0f)];
    if (textSize.height > 140) {
        while (textSize.height > 140) {
             textView.text = [textView.text substringToIndex:[textView.text length] - 1];
                   textSize = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), 120.0f)];
        }
        [SVProgressHUD showErrorWithStatus:@"已超过最大行数"];
    }
    
}


- (void)saveEvent{
    [SVProgressHUD showSuccessWithStatus:self.textView.text];
}

@end
