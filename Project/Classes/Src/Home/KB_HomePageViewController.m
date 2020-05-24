//
//  KB_HomePageViewController.m
//  Project
//
//  Created by hi  kobe on 2020/3/30.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_HomePageViewController.h"
#import "ZJScrollPageView.h"
#import "KB_BaseViewController.h"
#import "SmallVideoModel.h"

@interface KB_HomePageViewController ()<ZJScrollPageViewDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray<UIViewController<ZJScrollPageViewChildVcDelegate> *> *childVcs;
@property (weak, nonatomic) ZJScrollSegmentView *segmentView;
@property (weak, nonatomic) ZJContentView *contentView;

@end

@implementation KB_HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //必要的设置, 如果没有设置可能导致内容显示不正常
    if(@available(iOS 11.0, *)){
        //self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.childVcs = [self setupChildVc];
    // 初始化
    [self setupSegmentView];
    [self setupContentView];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (UIImage *)navigationBarBackgroundImage{
    return [[UIImage alloc] init];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    PageRout_Maneger.currentNaviVC = self.navigationController;
}
- (void)setupSegmentView {
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.showCover = NO;
    // 不要滚动标题, 每个标题将平分宽度
    style.scrollTitle = NO;
    style.showLine = YES;
    style.scrollLineColor = [UIColor whiteColor];
    style.titleFont = [UIFont systemFontOfSize:17 weight:bold];
    // 渐变
    style.gradualChangeTitleColor = YES;
    style.titleBigScale = 1.3;
    style.adjustCoverOrLineWidth = YES;
    // 遮盖背景颜色
    style.coverBackgroundColor = [UIColor whiteColor];
    //标题一般状态颜色 --- 注意一定要使用RGB空间的颜色值
    style.normalTitleColor = [UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1.0];
    //标题选中状态颜色 --- 注意一定要使用RGB空间的颜色值
    style.selectedTitleColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    
    self.titles = @[@"综合", @"美拍"];
    
    // 注意: 一定要避免循环引用!!
    @weakify(self);
    ZJScrollSegmentView *segment = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, 0, 160, NavigationBarHeight) segmentStyle:style delegate:self titles:self.titles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
        @strongify(self)
        [self.contentView setContentOffSet:CGPointMake(self.contentView.bounds.size.width * index, -TabBarHeight) animated:YES];
        
    }];
    // 自定义标题的样式
    segment.layer.cornerRadius = 14.0;
    segment.backgroundColor = [UIColor clearColor];
    self.segmentView = segment;
    self.navigationItem.titleView = self.segmentView;
    
}

- (void)setupContentView {
    
    ZJContentView *content = [[ZJContentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) segmentView:self.segmentView parentViewController:self delegate:self];
    self.contentView = content;
    [self.view addSubview:self.contentView];
    
}

- (NSArray *)setupChildVc {
    //推荐
    KB_BaseViewController *vc1 = [KB_BaseViewController new];
    vc1.homeType = HomeType_Recommend;
    vc1.currentPlayIndex = 0;

    //关注
    KB_BaseViewController  *vc2 = [KB_BaseViewController new];
    vc2.homeType = HomeType_Focus;
    vc2.currentPlayIndex = 0;

    NSArray *childVcs = [NSArray arrayWithObjects:vc1, vc2, nil];
    return childVcs;
}

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}




- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = self.childVcs[index];
    }
    
    return childVc;
}


-(CGRect)frameOfChildControllerForContainer:(UIView *)containerView {
    return  CGRectInset(containerView.bounds, 20, 20);
}



//- (void)getResource {
//    SmallVideoModel *model1 = [[SmallVideoModel alloc] init];
//    model1.rid = 1;
//    model1.name = @"model1";
//    model1.comment_num = 12;
//    model1.score = 11;
//    model1.artist = @"作者1";
//    model1.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/46/user_head_30881645_20190423071746.jpg";
//    model1.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/551/76097551.mp4";
//    model1.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/551/76097551.jpg";
//    model1.aspect = 1.778;
//
//    SmallVideoModel *model2 = [[SmallVideoModel alloc] init];
//    model2.rid = 2;
//    model2.name = @"model2";
//    model2.comment_num = 12;
//    model2.score = 21;
//    model2.artist = @"作者2";
//    model2.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/46/user_head_30881645_20190423071746.jpg";
//    model2.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/479/76097479.mp4";
//    model2.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/479/76097479.jpg";
//    model2.aspect = 1.778;
//
//    SmallVideoModel *model3 = [[SmallVideoModel alloc] init];
//    model3.rid = 3;
//    model3.name = @"model1";
//    model3.comment_num = 12;
//    model3.score = 31;
//    model3.artist = @"作者3";
//    model3.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/31/user_head_34964288_20190212001831.jpg";
//    model3.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/970/75779970.mp4";
//    model3.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/970/75779970.jpg";
//    model3.aspect = 1.778;
//
//    SmallVideoModel *model4 = [[SmallVideoModel alloc] init];
//    model4.rid = 4;
//    model4.name = @"model4";
//    model4.comment_num = 12;
//    model4.score = 41;
//    model4.artist = @"作者4";
//    model4.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/22/user_head_27430048_20190525064122.jpg";
//    model4.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/204/76097204.mp4";
//    model4.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/204/76097204.jpg";
//    model4.aspect = 1.250;
//
//    SmallVideoModel *model5 = [[SmallVideoModel alloc] init];
//    model5.rid = 5;
//    model5.name = @"model1";
//    model5.comment_num = 12;
//    model5.score = 51;
//    model5.artist = @"作者5";
//    model5.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/13/user_head_15486360_20190426173413.jpg";
//    model5.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/022/76097022.mp4";
//    model5.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/022/76097022.jpg";
//    model5.aspect = 1.799;
//
//    SmallVideoModel *model6 = [[SmallVideoModel alloc] init];
//    model6.rid = 6;
//    model6.name = @"model6";
//    model6.comment_num = 12;
//    model6.score = 61;
//    model6.artist = @"作者6";
//    model6.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/55/user_head_5925183_20190528092255.jpg";
//    model6.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/550/76097550.mp4";
//    model6.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/550/76097550.jpg";
//    model6.aspect = 0.567;
//
//    SmallVideoModel *model7 = [[SmallVideoModel alloc] init];
//    model7.rid = 7;
//    model7.name = @"model1";
//    model7.comment_num = 12;
//    model7.score = 71;
//    model7.artist = @"作者7";
//    model7.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/43/user_head_123737_20190424101443.jpg";
//    model7.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/488/75779488.mp4";
//    model7.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/488/75779488.jpg";
//    model7.aspect = 0.562;
//
//    SmallVideoModel *model8 = [[SmallVideoModel alloc] init];
//    model8.rid = 8;
//    model8.name = @"model1";
//    model8.comment_num = 12;
//    model8.score = 81;
//    model8.artist = @"作者8";
//    model8.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/47/user_head_20761695_20190526224947.jpg";
//    model8.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/809/76096809.mp4";
//    model8.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/809/76096809.jpg";
//    model8.aspect = 0.562;
//
//    SmallVideoModel *model9 = [[SmallVideoModel alloc] init];
//    model9.rid = 9;
//    model9.name = @"model9";
//    model9.comment_num = 12;
//    model9.score = 91;
//    model9.artist = @"作者9";
//    model9.head_url = @"http://thirdqq.qlogo.cn/g?b=oidb&amp;k=IXYXYnjFTRGWV18ibkgC6Kw&amp;s=100";
//    model9.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/603/76096603.mp4";
//    model9.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/603/76096603.jpg";
//    model9.aspect = 1.000;
//
//    SmallVideoModel *model10 = [[SmallVideoModel alloc] init];
//    model10.rid = 10;
//    model10.name = @"model1";
//    model10.comment_num = 12;
//    model10.score = 101;
//    model10.artist = @"作者10";
//    model10.head_url = @"http://thirdqq.qlogo.cn/g?b=oidb&amp;k=lzQZzzcCgg8j4XvcyPBGOA&amp;s=100";
//    model10.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/059/75778059.mp4";
//    model10.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/059/75778059.jpg";
//    model10.aspect = 1.778;
//
//    SmallVideoModel *model11 = [[SmallVideoModel alloc] init];
//    model11.rid = 11;
//    model11.name = @"model11";
//    model11.comment_num = 12;
//    model11.score = 111;
//    model11.artist = @"作者11";
//    model11.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/34/user_head_31365520_20190516093434.jpg";
//    model11.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/037/76096037.mp4";
//    model11.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/037/76096037.jpg";
//    model11.aspect = 1.778;
//
//    SmallVideoModel *model12 = [[SmallVideoModel alloc] init];
//    model12.rid = 12;
//    model12.name = @"model12";
//    model12.comment_num = 12;
//    model12.score = 121;
//    model12.artist = @"作者12";
//    model12.head_url = @"http://cdnuserprofilebd.shoujiduoduo.com/head_pic/34/user_head_31365520_20190516093434.jpg";
//    model12.video_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/video/029/76096029.mp4";
//    model12.cover_url = @"http://cdnringbd.shoujiduoduo.com/ringres/userv1/cover/029/76096029.jpg";
//    model12.aspect = 1.778;
//    [self.modelArray addObjectsFromArray:@[model1,model2,model3,model4,model5,model6,model7,model8,model9,model10,model11,model12]];
//}
@end
