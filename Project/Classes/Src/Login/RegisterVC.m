//
//  RegisterVC.m
//  Project
//
//  Created by hualv on 2020/4/15.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
}
- (UIImage *)navigationBarBackgroundImage{
    return [UIImage imageWithColor:UIColorMakeWithHex(@"#222222")];
}
- (UIColor *)navigationBarTintColor{
    return UIColorMakeWithHex(@"#FFFFFF");
}

@end
