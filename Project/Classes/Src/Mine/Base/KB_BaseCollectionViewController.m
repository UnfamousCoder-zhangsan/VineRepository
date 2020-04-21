//
//  KB_BaseCollectionViewController.m
//  Project
//
//  Created by hi  kobe on 2020/4/18.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_BaseCollectionViewController.h"
@interface KB_BaseCollectionViewController ()

@end

@implementation KB_BaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        DDAnimationLayout *layout = [[DDAnimationLayout alloc]init];
        layout.rowsOrColumnsCount = 3;
        layout.rowMargin = 0;
        layout.columnMargin = 0;
        layout.delegate = self;
        layout.sectionInset = UIEdgeInsetsMake(0, 4, 0, 4);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

#pragma mark -UICollectionViewDelegate , UICollectionViewDataSource -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 0;
}


//每一分区的单元个数

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}



//集合视图单元格大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeZero;
}


//单元格复用

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGSize)DDAnimationLayout:(DDAnimationLayout *)layout atIndexPath:(NSIndexPath *)indexPath{
    return CGSizeZero;
}
@end
