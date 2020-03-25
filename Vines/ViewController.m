//
//  ViewController.m
//  Vines
//
//  Created by hi  kobe on 2020/3/21.
//  Copyright © 2020 hi  kobe. All rights reserved.
//

#import "ViewController.h"
#import "JXCategoryView.h"

@interface ViewController ()<JXCategoryViewDelegate>
@property(nonatomic, strong)JXCategoryTitleView *categoryView;
@property(nonatomic, strong)UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化JXCategoryTitleView
    self.view.backgroundColor = [UIColor blackColor];
    self.categoryView  =[[JXCategoryTitleView alloc] initWithFrame:CGRectMake(80, 44, self.view.bounds.size.width - 160, 50)];
    self.categoryView.backgroundColor = [UIColor clearColor];
    self.categoryView.delegate = self;
    [self.view addSubview:self.categoryView];
    
    //配置JXCategoryTitleView的属性
    self.categoryView.titles = @[@"关注",@"推荐"];
    self.categoryView.titleFont = [UIFont systemFontOfSize:20];
    self.categoryView.titleSelectedFont = [UIFont systemFontOfSize:25];
    self.categoryView.titleColor = [UIColor grayColor]; //默认颜色
    self.categoryView.titleSelectedColor = [UIColor whiteColor]; //选中颜色
    self.categoryView.defaultSelectedIndex = 1;
    self.categoryView.titleColorGradientEnabled = YES;
    //添加指示器
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor whiteColor];
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    self.categoryView.indicators = @[lineView];
    
    //self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    //创建图片
    UIImage *image = [UIImage imageNamed:@""];
    
    //拉伸图片
    [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    
}

#pragma make - JXCategoryViewDelegate -
//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
     NSLog(@"%@",@(index));
}

//滚动选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index{
    NSLog(@"%@",@(index));
}

    //正在滚动中的回调
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio{
    
}

@end
