

#import "QDCommonViewController.h"

@interface JWCollectionViewController : QDCommonViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/// 添加下拉刷新
/// @param block 下拉加载回调
- (void)addPullRefreshWithBlock:(nullable void (^)(void))block;

/// 添加上拉加载更多
/// @param block 上拉加载回调
- (void)addLoadingMoreWithBlock:(nullable void (^)(void))block;

/// 停止上拉加载更多并隐藏footer
- (void)endRefreshWithFooterHidden;

@property (nonatomic, strong) UICollectionView *collectionView;
@end
