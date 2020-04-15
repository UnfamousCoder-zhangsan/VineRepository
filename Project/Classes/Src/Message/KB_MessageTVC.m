//
//  KB_MessageTVC.m
//  Project
//
//  Created by hi  kobe on 2020/4/6.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_MessageTVC.h"
#import "KB_MessageHeaderView.h"

@interface KB_MessageTVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) KB_MessageHeaderView *headeView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation KB_MessageTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorMakeWithHex(@"#222222");
    self.titleView.title = @"消息";
    [self initUI];
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
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"listCell"];
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
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行", indexPath.row + 1];
    return cell;
}

@end
