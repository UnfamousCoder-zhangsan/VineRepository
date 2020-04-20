//
//  KB_PublishCell.m
//  Project
//
//  Created by hi  kobe on 2020/4/19.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_PublishCell.h"
@interface KB_PublishCell()<QMUITextViewDelegate>

@property (weak, nonatomic) IBOutlet QMUITextView *textView;

@end

@implementation KB_PublishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.delegate = self;
    // 图片添加点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapped)];
    [self.uploadImageView addGestureRecognizer:tapGesture];
}

- (BOOL)textViewShouldReturn:(QMUITextView *)textView {
    // return YES 表示这次 return 按钮的点击是为了触发“发送”，而不是为了输入一个换行符
    //收起键盘
    [self.textView resignFirstResponder];
    return YES;
}
// 将文字实时传递出去
- (void)textViewDidChange:(UITextView *)textView{
    if (self.textViewBlock) {
        self.textViewBlock(textView.text);
    }
}

- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"标题不超过%@个字符",@(textView.maximumTextLength)]];
}
#pragma mark - 点击查看图片 -
- (void)imageTapped{
    if (self.imageViewTapBlock) {
        self.imageViewTapBlock();
    }
}
@end
