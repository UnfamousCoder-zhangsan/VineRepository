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
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"KB_MessageListCell" bundle:nil] forCellReuseIdentifier:@"KB_MessageListCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KB_MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KB_MessageListCell"];
    cell.model = self.dataArray[indexPath.row];
    // 取消选中背景
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)getData{
    MessageListModel *model1 = [[MessageListModel alloc] init];
    model1.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model1.userName = @"dsda啊";
    if (self.type == CellType_Fan) {
        model1.type = @"该用户关注了你";
    }else if (self.type == CellType_Like){
        model1.type = @"该用户给你的视频点赞了";
    }else if (self.type == CellType_Comment){
        model1.type = @"该用户评论了你";
        model1.comment = @"可以 6666";
    }
    model1.time = 1589858374064;
    
    MessageListModel *model2 = [[MessageListModel alloc] init];
    model2.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model2.userName = @"是大哥";
    if (self.type == CellType_Fan) {
        model2.type = @"该用户关注了你";
    }else if (self.type == CellType_Like){
        model2.type = @"该用户给你的视频点赞了";
    }else if (self.type == CellType_Comment){
        model2.type = @"该用户评论了你";
        model2.comment = @"可以 6666";
    }
    model2.time = 1589858374064;
    
    MessageListModel *model3 = [[MessageListModel alloc] init];
    model3.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model3.userName = @"是大哥";
    if (self.type == CellType_Fan) {
        model3.type = @"该用户关注了你";
    }else if (self.type == CellType_Like){
        model3.type = @"该用户给你的视频点赞了";
    }else if (self.type == CellType_Comment){
        model3.type = @"该用户评论了你";
        model3.comment = @"可以 6666";
    }
    model3.time = 1589858374064;
    
    MessageListModel *model4 = [[MessageListModel alloc] init];
    model4.userName = @"是大哥";
    if (self.type == CellType_Fan) {
        model4.type = @"该用户关注了你";
    }else if (self.type == CellType_Like){
        model4.type = @"该用户给你的视频点赞了";
    }else if (self.type == CellType_Comment){
        model4.type = @"该用户评论了你";
        model4.comment = @"可以 6666";
    }
    model4.time = 1589858374064;
    
    MessageListModel *model5 = [[MessageListModel alloc] init];
    model5.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model5.userName = @"是大哥";
    if (self.type == CellType_Fan) {
        model5.type = @"该用户关注了你";
    }else if (self.type == CellType_Like){
        model5.type = @"该用户给你的视频点赞了";
    }else if (self.type == CellType_Comment){
        model5.type = @"该用户评论了你";
        model5.comment = @"可以 6666";
    }
    model5.time = 1589858374064;
    
    MessageListModel *model6 = [[MessageListModel alloc] init];
    model6.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model6.userName = @"是大哥";
    if (self.type == CellType_Fan) {
        model6.type = @"该用户关注了你";
    }else if (self.type == CellType_Like){
        model6.type = @"该用户给你的视频点赞了";
    }else if (self.type == CellType_Comment){
        model6.type = @"该用户评论了你";
        model6.comment = @"可以 6666";
    }
    model6.time = 1589858374064;
    
    MessageListModel *model7 = [[MessageListModel alloc] init];
    model7.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model7.userName = @"是大哥";
    if (self.type == CellType_Fan) {
        model7.type = @"该用户关注了你";
    }else if (self.type == CellType_Like){
        model7.type = @"该用户给你的视频点赞了";
    }else if (self.type == CellType_Comment){
        model7.type = @"该用户评论了你";
        model7.comment = @"可以 6666";
    }
    model7.time = 1589858374064;
    
    MessageListModel *model8 = [[MessageListModel alloc] init];
    model8.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
    model8.userName = @"是大哥";
    if (self.type == CellType_Fan) {
        model8.type = @"该用户关注了你";
    }else if (self.type == CellType_Like){
        model8.type = @"该用户给你的视频点赞了";
    }else if (self.type == CellType_Comment){
        model8.type = @"该用户评论了你";
        model8.comment = @"可以 6666";
    }
    model8.time = 1589858374064;
    
    
    MessageListModel *model9 = [[MessageListModel alloc] init];
    model9.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/34/user_head_31365520_20190516093434.jpg";
    model9.userName = @"是大哥";
    if (self.type == CellType_Fan) {
        model9.type = @"该用户关注了你";
    }else if (self.type == CellType_Like){
        model9.type = @"该用户给你的视频点赞了";
    }else if (self.type == CellType_Comment){
        model9.type = @"该用户评论了你";
        model9.comment = @"可以 6666";
    }
    model9.time = 1589858374064;
    
    MessageListModel *model10 = [[MessageListModel alloc] init];
    
    model10.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/34/user_head_31365520_20190516093434.jpg";
    model2.userName = @"是大哥";
    if (self.type == CellType_Fan) {
        model10.type = @"该用户关注了你";
    }else if (self.type == CellType_Like){
        model10.type = @"该用户给你的视频点赞了";
    }else if (self.type == CellType_Comment){
        model10.type = @"该用户评论了你";
        model10.comment = @"可以 6666";
    }
    model10.time = 1589858374064;
    
    
    MessageListModel *model11 = [[MessageListModel alloc] init];
    model11.headerUrl = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/34/user_head_31365520_20190516093434.jpg";
    model11.userName = @"是大哥";
    if (self.type == CellType_Fan) {
        model11.type = @"该用户关注了你";
    }else if (self.type == CellType_Like){
        model11.type = @"该用户给你的视频点赞了";
    }else if (self.type == CellType_Comment){
        model11.type = @"该用户评论了你";
        model11.comment = @"可以 6666";
    }
    model11.time = 1589858374064;
    
    [self.dataArray addObjectsFromArray:@[model1,model2,model3,model4,model5,model6,model7,model8,model9,model10,model11]];
}
@end
