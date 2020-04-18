//
//  KB_BaseCollectionListViewController.m
//  Project
//
//  Created by hi  kobe on 2020/4/18.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_BaseCollectionListViewController.h"
#import "KB_MineCollectionViewCell.h"

@interface KB_BaseCollectionListViewController ()

@property (nonatomic, strong) UIImageView   *loadingView;
@property (nonatomic, strong) UILabel       *loadLabel;

@property (nonatomic, copy) void(^listScrollViewScrollCallback)(UIScrollView *scrollView);

@end

@implementation KB_BaseCollectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.count = 0;
    [self.collectionView registerNib:[UINib nibWithNibName:@"KB_MineCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"KB_MineCollectionViewCell"];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.count += 20;
            
            if (self.count >= 100) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.collectionView.mj_footer endRefreshing];
            }
            [self.collectionView reloadData];
        });
    }];
    
    if (self.shouldLoadData) {
        [self.collectionView addSubview:self.loadingView];
        [self.collectionView addSubview:self.loadLabel];
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView).offset(40.0f);
            make.centerX.equalTo(self.collectionView);
        }];
        
        [self.loadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loadingView.mas_bottom).offset(10.0f);
            make.centerX.equalTo(self.loadingView);
        }];
        
        [self loadData];
    }
}

- (void)loadData {
    self.count = 0;
    
    [self showLoading];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.count = 30;
        
        [self hideLoading];
        
        [self.collectionView reloadData];
    });
}

- (void)showLoading {
    self.loadingView.hidden = NO;
    self.loadLabel.hidden   = NO;
    [self.loadingView startAnimating];
}

- (void)hideLoading {
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
    self.loadLabel.hidden   = YES;
}

- (void)addHeaderRefresh {
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView.mj_header endRefreshing];
            
            self.count = 30;
            [self.collectionView reloadData];
        });
    }];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.collectionView.mj_footer.hidden = self.count == 0;
    return self.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KB_MineCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"KB_MineCollectionViewCell" forIndexPath:indexPath];
    return item;
}

#pragma mark - <DDAnimationLayoutDelegate>
- (CGSize)DDAnimationLayout:(DDAnimationLayout *) layout atIndexPath:(NSIndexPath *) indexPath {
    return CGSizeMake((SCREEN_WIDTH- 8) / 3, 120);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.listScrollViewScrollCallback ? : self.listScrollViewScrollCallback(scrollView);
}

#pragma mark - GKPageListViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.listScrollViewScrollCallback = callback;
}

- (UIImage *)changeImageWithImage:(UIImage *)image color:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 懒加载
- (UIImageView *)loadingView {
    if (!_loadingView) {
        NSMutableArray *images = [NSMutableArray new];
        for (NSInteger i = 0; i < 4; i++) {
            NSString *imageName = [NSString stringWithFormat:@"cm2_list_icn_loading%zd", i + 1];
            
            UIImage *img = [self changeImageWithImage:[UIImage imageNamed:imageName] color:[UIColor redColor]];
            
            [images addObject:img];
        }
        
        for (NSInteger i = 4; i > 0; i--) {
            NSString *imageName = [NSString stringWithFormat:@"cm2_list_icn_loading%zd", i];
            
            UIImage *img = [self changeImageWithImage:[UIImage imageNamed:imageName] color:[UIColor redColor]];
            
            [images addObject:img];
        }
        
        UIImageView *loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
        loadingView.animationImages     = images;
        loadingView.animationDuration   = 0.75;
        loadingView.hidden              = YES;
        
        _loadingView = loadingView;
    }
    return _loadingView;
}

- (UILabel *)loadLabel {
    if (!_loadLabel) {
        _loadLabel              = [UILabel new];
        _loadLabel.font         = [UIFont systemFontOfSize:14.0f];
        _loadLabel.textColor    = [UIColor grayColor];
        _loadLabel.text         = @"正在加载...";
        _loadLabel.hidden       = YES;
    }
    return _loadLabel;
}

@end
