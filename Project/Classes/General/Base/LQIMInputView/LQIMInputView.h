//
//  LQIMInputView.h
//  LQIMInputView
//
//  Created by lawchat on 2016/10/25.
//  Copyright © 2016年 674297026@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputItem.h"
#import "PayInputItem.h"

@interface LQIMInputView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong) UIPageControl *pageCtr;

@property(nonatomic,strong) NSMutableArray<InputItemModel*> *itemModels;


- (instancetype)initWithFrame:(CGRect)frame;

- (void)addItem:(InputItemModel*)model;

@end
