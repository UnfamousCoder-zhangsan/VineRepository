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
    self.tableView.backgroundColor = UIColorWhite;
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    } else {
        return 20;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 5:
                //联系客服
                [UtilsHelper callPhone:@"13208196091"];
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1) {
        
    }
}
@end
