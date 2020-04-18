//
//  KB_BaseCollectionViewController.h
//  Project
//
//  Created by hi  kobe on 2020/4/18.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "QDCommonViewController.h"
#import "DDAnimationLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface KB_BaseCollectionViewController : QDCommonViewController<UICollectionViewDelegate,UICollectionViewDataSource, DDAnimationLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@end

NS_ASSUME_NONNULL_END
