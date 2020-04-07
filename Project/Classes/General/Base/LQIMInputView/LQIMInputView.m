//
//  LQIMInputView.m
//  LQIMInputView
//
//  Created by lawchat on 2016/10/25.
//  Copyright © 2016年 674297026@qq.com. All rights reserved.
//

#import "LQIMInputView.h"
#import "LQCollectionViewHorizontalLayout.h"
#define kCollectionViewTop 23  //
@interface LQIMInputView()
@end
@implementation LQIMInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addLine];//add
        
        [self addSubview:self.pageCtr];
    }
    return self;
}
-(void)addLine{
    UIView *line = [UIView new];
    [self addSubview:line];
    line.backgroundColor = UIColorMakeWithHex(@"f0f0f0");
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
        
    }];
}
- (void)addItem:(InputItemModel*)model {
    if (!self.itemModels) {
        self.itemModels = [NSMutableArray array];
    }
    [self.itemModels addObject:model];
  
    if(![self.subviews containsObject:self.collectionView]){
        if(model.inputItemModelType == InputItemModelType_Pay){
            self.collectionView = [self payCollectionView];
        }else{
            self.collectionView = [self getCollectionView];
        }
        [self addSubview:self.collectionView];
    }else{
        
         [self.collectionView reloadData];
    }
   
    
    NSInteger pageNum = (_itemModels.count-1) / 8 + 1;
    if (pageNum>1) {
        _pageCtr.numberOfPages = pageNum;
        _pageCtr.currentPage = 0;
    }
}

#pragma mark - 页码控件
- (UIPageControl *)pageCtr {
    if (!_pageCtr) {
        _pageCtr = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0,200, 10)];
        _pageCtr.center = CGPointMake(self.bounds.size.width / 2.0, self.collectionView.bounds.size.height);
        
        _pageCtr.pageIndicatorTintColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
        _pageCtr.currentPageIndicatorTintColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];

        _pageCtr.userInteractionEnabled  = NO;
    }
    return _pageCtr;
}

#pragma mark - collectionView
- (UICollectionView *)getCollectionView {
    //功能列表
    LQCollectionViewHorizontalLayout *layout       = [[LQCollectionViewHorizontalLayout alloc] init];
    layout.itemSize                                = CGSizeMake([UIScreen mainScreen].bounds.size.width/4.0, (CGRectGetHeight(self.bounds)-40) / 2.0);
    layout.minimumLineSpacing                      = 0;
    layout.minimumInteritemSpacing                 = 0;
    layout.headerReferenceSize                     = CGSizeMake(0, 0);
    layout.scrollDirection                         = UICollectionViewScrollDirectionHorizontal;
    
      UICollectionView *collectionView   = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-40) collectionViewLayout:layout];
    collectionView.backgroundColor                = [UIColor clearColor];
    collectionView.pagingEnabled                  = YES;
    collectionView.delegate                       = self;
    collectionView.dataSource                     = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator   = NO;
    
    [collectionView registerClass:[InputItem class] forCellWithReuseIdentifier:@"InputItem"];
    return collectionView;
}
- (UICollectionView *)payCollectionView {
    
    
    CGFloat itemW = 59.0;
    CGFloat itemH = 90;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemW,itemH);
    layout.minimumLineSpacing = 31;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(0, 0);
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  
    
  UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kCollectionViewTop, CGRectGetWidth(self.bounds),itemH) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    

    [collectionView registerNib:[UINib nibWithNibName:@"PayInputItem" bundle:nil] forCellWithReuseIdentifier:@"PayInputItem"];
    


    return collectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InputItemModel *model = self.itemModels[indexPath.item];
    if (model.inputItemModelType == InputItemModelType_Pay) {
          PayInputItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PayInputItem" forIndexPath:indexPath];
         cell.model = model;
        return cell;
    }else{
         InputItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InputItem" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
  
}


#pragma mark - 选择了某功能
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    InputItemModel *item = self.itemModels[indexPath.item];
    if (item.clickedBlock) {
        item.clickedBlock();
    }
}

#pragma mark - 滚动视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /**
     *  滚动设置当前页码
     */
    int page = (int)(self.collectionView.contentOffset.x / scrollView.bounds.size.width + 0.5) % _itemModels.count;
    _pageCtr.currentPage = page;
}

@end
