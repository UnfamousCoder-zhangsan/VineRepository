//
//  KB_PersonalInformationVC.m
//  Project
//
//  Created by hi  kobe on 2020/4/12.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_PersonalInformationVC.h"
#import "PersonalInformationHeaderView.h"
#import "KB_ModifyNameVC.h"
#import "KB_ModifyIntroductionVC.h"

@interface KB_PersonalInformationVC ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *Labe;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (nonatomic, strong) PersonalInformationHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *brithdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *arealabel;

@end

@implementation KB_PersonalInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = UIColorMakeWithHex(@"#FFFFFF");
    self.title = @"编辑个人资料";
    self.nameLabel.text = self.model.nickname;
    self.accountLabel.text = self.model.id;
    self.Labe.text = @"暂未填写简介";
    self.schoolLabel.text = @"电子科技大学成都学院";
    self.genderLabel.text = @"";
    self.brithdayLabel.text = @"";
    self.arealabel.text= @"";
    [self.headerView.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@%@",kAddressUrl,self.model.faceImage]] placeholderImage:nil];
    [self.tableView reloadData];
}


- (void)setupNavigationItems{
    [super setupNavigationItems];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"保存" target:self action:@selector(saveData)];
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
        KB_ModifyNameVC *vc =[[UIStoryboard storyboardWithName:@"Setting" bundle:nil] instantiateViewControllerWithIdentifier:@"KB_ModifyNameVC"];
        vc.nameString = self.nameLabel.text;
        [PageRout_Maneger.currentNaviVC pushViewController:vc animated:YES];
        
    } else if(indexPath.row == 1){
        // 设置账号
    } else if(indexPath.row == 2){
        KB_ModifyIntroductionVC *vc =[[UIStoryboard storyboardWithName:@"Setting" bundle:nil] instantiateViewControllerWithIdentifier:@"KB_ModifyIntroductionVC"];
        [PageRout_Maneger.currentNaviVC pushViewController:vc animated:YES];
    } else if(indexPath.row == 3){
        // 学校
    } else if(indexPath.row == 4){
        // 性别
        NSArray *arr = @[@"男", @"女", @"未知"];
        [BRStringPickerView showStringPickerWithTitle:@"选择性别" dataSource:arr defaultSelValue:arr[2] resultBlock:^(NSString *selectValue) {
            LQLog(@"%@",selectValue);
            self.genderLabel.text = selectValue;
            
        }];
    } else if(indexPath.row == 5){
        // 生日
        NSString *birthdayStr;
        if (!self.brithdayLabel) {
            birthdayStr = @"1930-01-01";
        } else {
            birthdayStr = self.brithdayLabel.text;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *minDate = [dateFormatter dateFromString:@"1900-01-01"];
        NSDate *MaxDate = [NSDate date];
        [BRDatePickerView showDatePickerWithTitle:@"选择生日" dateType:BRDatePickerModeYMD defaultSelValue:birthdayStr minDate:minDate maxDate:MaxDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
            self.brithdayLabel.text = selectValue;
        } cancelBlock:^{
            
        }];
    } else if(indexPath.row == 6){
        // 地区
        NSArray *areaArray;
        if (!self.arealabel.text) {
            areaArray = @[@"四川省",@"成都市",@"金牛区"];
        } else {
            areaArray = [self.arealabel.text componentsSeparatedByString:@"."];
        }
        [BRAddressPickerView showAddressPickerWithDefaultSelected:areaArray resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
            //
            self.arealabel.text = [NSString stringWithFormat:@"%@.%@.%@",province.name,city.name,area.name];
        }];
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

- (void)setModel:(InformationModel *)model{
    _model = model;
}

- (void)saveData{
    [SVProgressHUD showWithStatus:@"保存中"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    });
}
@end
