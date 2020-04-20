//
//  KB_PublishViewController.m
//  Project
//
//  Created by hi  kobe on 2020/4/19.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_PublishViewController.h"
#import "KB_PublishCell.h"

@interface KB_PublishViewController ()<UITableViewDelegate,UITableViewDataSource>{
    QMUIButton *_publishBtn;
    UITableView *_tableView;
}
@property(nonatomic, strong) NSString *titleText;
@end

@implementation KB_PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布";
    [self initUI];
}
- (void)initUI{
    
    //bottomView
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = UIColorMakeWithHex(@"#222222");
    [self.view addSubview:bottomView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UIColorMakeWithHex(@"#222222");
    [_tableView registerNib:[UINib nibWithNibName:@"KB_PublishCell" bundle:nil] forCellReuseIdentifier:@"KB_PublishCell"];
    [self.view addSubview:_tableView];
    _publishBtn = [[QMUIButton alloc] init];
    [_publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_publishBtn setBackgroundImage:UIImageMake(@"") forState:UIControlStateNormal];
    [_publishBtn setBackgroundColor:UIColorMakeWithHex(@"#FFFFFF")];
    [_publishBtn addTarget:self action:@selector(updateVideoToService) forControlEvents:UIControlEventTouchUpInside];
    _publishBtn.layer.cornerRadius = 5;
    [bottomView addSubview:_publishBtn];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.with.offset(0);
        make.height.with.offset(SafeAreaInsetsConstantForDeviceWithNotch.bottom + 60);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(self.view).offset(0);
        make.bottom.mas_equalTo(bottomView.mas_top).offset(0);
    }];
    [_publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView.mas_top).offset(0);
        make.centerX.mas_equalTo(bottomView.mas_centerX).offset(0);
        make.width.with.offset(SCREEN_WIDTH - 100);
        make.height.with.offset(50);
    }];
}
- (void)setImage:(UIImage *)image{
    _image = image;
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KB_PublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KB_PublishCell"];
    cell.image.image = self.image;
    @weakify(self)
    cell.textViewBlock = ^(NSString * str) {
        @strongify(self)
        self.titleText = str;
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 132;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

#pragma mark - 上传 -
- (void)updateVideoToService{
    
}
@end
