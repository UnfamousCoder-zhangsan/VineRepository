//
//  KB_PrivacyPolicyVC.h
//  Project
//
//  Created by hi  kobe on 2020/5/12.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, TextType)
{
    TextType_Convention = 0,//
    TextType_Protocol = 1,//
    TextType_privacy = 2
};

@interface KB_PrivacyPolicyVC : QDCommonViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, assign) TextType type;

@end

NS_ASSUME_NONNULL_END
