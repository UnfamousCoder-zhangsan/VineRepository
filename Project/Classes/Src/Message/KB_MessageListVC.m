//
//  KB_MessageListVC.m
//  Project
//
//  Created by hikobe on 2020/5/19.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_MessageListVC.h"
#import "KB_MessageListCell.h"
#import "MessageListModel.h"

@interface KB_MessageListVC ()
@property(nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation KB_MessageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getData];
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)initTableView{
    [super initTableView];
    self.tableView.backgroundColor = [UIColor whiteColor];//UIColorMakeWithHex(@"#666666");
    [self.tableView registerNib:[UINib nibWithNibName:@"KB_MessageListCell" bundle:nil] forCellReuseIdentifier:@"KB_MessageListCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KB_MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KB_MessageListCell"];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)getData{
    MessageListModel *model1 = [[MessageListModel alloc] init];
    model1.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model1.userName = @"测试";
    model1.comment = @"评论";
    model1.type = @"发表了评论";
    model1.time = 1589858374064;
    
    MessageListModel *model2 = [[MessageListModel alloc] init];
    model2.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model2.userName = @"测试";
    model2.comment = @"评论";
    model2.type = @"发表了评论";
    model2.time = 1589858374064;
    
    MessageListModel *model3 = [[MessageListModel alloc] init];
    model3.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model3.userName = @"测试";
    model3.comment = @"评论";
    model3.type = @"发表了评论";
    model3.time = 1589858374064;
    
    MessageListModel *model4 = [[MessageListModel alloc] init];
    model4.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model4.userName = @"测试";
    model4.comment = @"评论";
    model4.type = @"发表了评论";
    model4.time = 1589858374064;
    
    MessageListModel *model5 = [[MessageListModel alloc] init];
    model5.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model5.userName = @"测试";
    model5.comment = @"评论";
    model5.type = @"发表了评论";
    model5.time = 1589858374064;
    
    MessageListModel *model6 = [[MessageListModel alloc] init];
    model6.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model6.userName = @"测试";
    model6.comment = @"评论";
    model6.type = @"发表了评论";
    model6.time = 1589858374064;
    
    MessageListModel *model7 = [[MessageListModel alloc] init];
    model7.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model7.userName = @"测试";
    model7.comment = @"评论";
    model7.type = @"发表了评论";
    model7.time = 1589858374064;
    
    MessageListModel *model8 = [[MessageListModel alloc] init];
    model8.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model8.userName = @"测试";
    model8.comment = @"评论";
    model8.type = @"发表了评论";
    model8.time = 1589858374064;
    
    
    MessageListModel *model9 = [[MessageListModel alloc] init];
    model9.headerUrl = @"http://thirdqq.qlogo.cn/g?b=oidb&amp;k=IXYXYnjFTRGWV18ibkgC6Kw&amp;s=100";
    model9.userName = @"测试";
    model9.comment = @"评论";
    model9.type = @"发表了评论";
    model9.time = 1589858374064;
    
    MessageListModel *model10 = [[MessageListModel alloc] init];
    
    model10.headerUrl = @"http://thirdqq.qlogo.cn/g?b=oidb&amp;k=lzQZzzcCgg8j4XvcyPBGOA&amp;s=100";
    model10.userName = @"测试";
    model10.comment = @"评论";
    model10.type = @"发表了评论";
    model10.time = 1589858374064;
    
    
    MessageListModel *model11 = [[MessageListModel alloc] init];
    model11.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/34/user_head_31365520_20190516093434.jpg";
    model11.userName = @"测试";
    model11.comment = @"评论";
    model11.type = @"发表了评论";
    model11.time = 1589858374064;
    
    [self.dataArray addObjectsFromArray:@[model1,model2,model3,model4,model5,model6,model7,model8,model9,model10,model11]];
}
@end
