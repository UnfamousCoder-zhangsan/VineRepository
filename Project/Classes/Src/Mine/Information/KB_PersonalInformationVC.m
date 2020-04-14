//
//  KB_PersonalInformationVC.m
//  Project
//
//  Created by hi  kobe on 2020/4/12.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_PersonalInformationVC.h"
#import "PersonalInformationHeaderView.h"

@interface KB_PersonalInformationVC ()
@property (nonatomic, strong) PersonalInformationHeaderView *headerView;
@end

@implementation KB_PersonalInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"编辑个人资料";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击事件响应
    if (indexPath.row == 0) {
        //设置昵称
    } else if(indexPath.row == 1){
        // 设置账号
    } else if(indexPath.row == 2){
        // 简介
    } else if(indexPath.row == 3){
        // 学校
    } else if(indexPath.row == 4){
        // 性别
        NSArray *arr = @[@"男", @"女", @"未知"];
        [BRStringPickerView showStringPickerWithTitle:@"选择性别" dataSource:arr defaultSelValue:arr[2] resultBlock:^(id selectValue) {
            LQLog(@"%@",selectValue);
        }];
    } else if(indexPath.row == 5){
        // 生日
        NSDate *minDate = [NSDate date];
        NSDate *MaxDate = [NSDate date];
        [BRDatePickerView showDatePickerWithTitle:@"选择生日" dateType:BRDatePickerModeYMD defaultSelValue:@"等时间" minDate:minDate maxDate:MaxDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
            
        } cancelBlock:^{
            
        }];
    } else if(indexPath.row == 6){
        // 地区
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 200;
}

- (PersonalInformationHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"PersonalInformationHeaderView" owner:nil options:nil].firstObject;
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    }
    return _headerView;
}
@end
