//
//  KB_SettingInformationVC.m
//  Project
//
//  Created by hualv on 2020/4/13.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_SettingInformationVC.h"

@interface KB_SettingInformationVC ()

@end

@implementation KB_SettingInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
}

- (UIImage *)navigationBarShadowImage{
    return  [UIImage imageWithColor:UIColorMakeWithHex(@"#FFFFFF")];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    } else {
        return 1;
    }
}
@end
