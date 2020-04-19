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
}

- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText{
    if (textView.text.length > 55) {
        [SVProgressHUD showErrorWithStatus:@"最大字符不超过55个字"];
    }
}


@end
