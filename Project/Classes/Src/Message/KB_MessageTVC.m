//
//  KB_MessageTVC.m
//  Project
//
//  Created by hi  kobe on 2020/4/6.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_MessageTVC.h"
#import "KB_MessageHeaderView.h"
#import "KB_MessageListCell.h"

@interface KB_MessageTVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) KB_MessageHeaderView *headeView;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation KB_MessageTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorMakeWithHex(@"#222222");
    self.titleView.title = @"消息";
    [self initUI];
    [self getData];
    //[self showNoDataEmptyViewWithText:@"暂无新消息" detailText:@"前往首页查看更多精彩内容"];
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    PageRout_Maneger.currentNaviVC = self.navigationController;
}
- (BOOL)layoutEmptyView{
    self.emptyView.frame = CGRectMake(0, 100 + NavigationContentTopConstant, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTopConstant - TabBarHeight - 100);
    return YES;
}
- (UIImage *)navigationBarShadowImage{
    return [UIImage imageWithColor:UIColorMakeWithHex(@"#444444")];
}
- (KB_MessageHeaderView *)headeView{
    if (!_headeView) {
        _headeView = [[NSBundle mainBundle] loadNibNamed:@"KB_MessageHeaderView" owner:nil options:nil].firstObject;
        _headeView.frame = CGRectMake(0, NavigationContentTopConstant, SCREEN_WIDTH, 100);
        
    }
    return _headeView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.tableView registerNib:[UINib nibWithNibName:@"KB_MessageListCell" bundle:nil] forCellReuseIdentifier:@"KB_MessageListCell"];
        _tableView.backgroundColor = UIColorMakeWithHex(@"#555555");
    }
    return _tableView;
}
- (void)initUI{
    [self.view addSubview:self.headeView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headeView.mas_bottom).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KB_MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KB_MessageListCell"];
    cell.model = self.dataArray[indexPath.row];
    // 取消选中背景
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)getData{
    [self showEmptyViewWithLoading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self hideEmptyView];
        MessageListModel *model1 = [[MessageListModel alloc] init];
        model1.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
        model1.userName = @"dsda啊";
        model1.time = 1589858374064;
        
        MessageListModel *model2 = [[MessageListModel alloc] init];
        model2.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
        model2.userName = @"是大哥";
        model2.type = @"该用户评论了你";
        model2.comment = @"可以 6666";
        model2.time = 1589858374064;
        
        MessageListModel *model3 = [[MessageListModel alloc] init];
        model3.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
        model3.userName = @"是大哥";
        model2.type = @"该用户评论了你";
        model2.comment = @"可以 6666";
        model3.time = 1589858374064;
        
        MessageListModel *model4 = [[MessageListModel alloc] init];
        model4.userName = @"是大哥";
        model2.type = @"该用户评论了你";
        model2.comment = @"可以 6666";
        model4.time = 1589858374064;
        
        MessageListModel *model5 = [[MessageListModel alloc] init];
        model5.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
        model5.userName = @"是大哥";
        model2.type = @"该用户评论了你";
        model2.comment = @"可以 6666";
        model5.time = 1589858374064;
        
        MessageListModel *model6 = [[MessageListModel alloc] init];
        model6.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
        model6.userName = @"是大哥";
        model2.type = @"该用户评论了你";
        model2.comment = @"可以 6666";
        model6.time = 1589858374064;
        
        MessageListModel *model7 = [[MessageListModel alloc] init];
        model7.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
        model7.userName = @"是大哥";
        model2.type = @"该用户评论了你";
        model2.comment = @"可以 6666";
        model7.time = 1589858374064;
        
        MessageListModel *model8 = [[MessageListModel alloc] init];
        model8.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
        model8.userName = @"是大哥";
        model2.type = @"该用户评论了你";
        model2.comment = @"可以 6666";
        model8.time = 1589858374064;
        
        
        MessageListModel *model9 = [[MessageListModel alloc] init];
        model9.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/34/user_head_31365520_20190516093434.jpg";
        model9.userName = @"是大哥";
        model2.type = @"该用户评论了你";
        model2.comment = @"可以 6666";
        model9.time = 1589858374064;
        
        MessageListModel *model10 = [[MessageListModel alloc] init];
        
        model10.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/34/user_head_31365520_20190516093434.jpg";
        model2.userName = @"是大哥";
        model2.type = @"该用户评论了你";
        model2.comment = @"可以 6666";
        model10.time = 1589858374064;
        
        
        MessageListModel *model11 = [[MessageListModel alloc] init];
        model11.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/34/user_head_31365520_20190516093434.jpg";
        model11.userName = @"是大哥";
        model2.type = @"该用户评论了你";
        model2.comment = @"可以 6666";
        model11.time = 1589858374064;
        
        [self.dataArray addObjectsFromArray:@[model1,model2,model3,model4,model5,model6,model7,model8,model9,model10,model11]];
        [self.tableView reloadData];
    });
}

@end
