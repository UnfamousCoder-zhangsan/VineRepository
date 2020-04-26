//
//  CommentsPopView.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "CommentsPopView.h"

#import "CommentMessageCell.h"
//#import "IQKeyboardManager.h"
#import "CommentInputView.h"
#import "CommentTextView.h"
//#import "UIButton+CustomCategory.h"
#import "CommentModel.h"


static NSString *const commentMessageCellIdentifier = @"commentMessageCellIdentifier";
static NSString *const replyCommentMessageCellIdentifier = @"replyCommentMessageCellIdentifier";


@interface CommentsPopView () <UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate,UIScrollViewDelegate, CommentMessageCellDelegate, CommentTextViewDelegate>

@property (nonatomic, strong) KB_HomeVideoDetailModel *videoModel;

@property (nonatomic, strong) UIView                           *container;
@property (nonatomic, strong) UITableView                      *tableView;
@property (nonatomic, strong) CommentTextView                  *commentTextView;
@property (nonatomic, strong) UILabel           *numCommentLabel;
@property (nonatomic, strong) UIButton *closeBtn;


//最热评论数组
@property(nonatomic, strong) NSMutableArray<CommentModel *> *hotCommentArray;

@property (nonatomic)       int             pageIndex;
@property (nonatomic)       int             pageCount;
@property (nonatomic) BOOL hasMore;


@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
//当前正在拖拽的是否是tableView
@property (nonatomic, assign) BOOL isDragTableView;
//向下拖拽最后时刻的位移
@property (nonatomic, assign) CGFloat lastDrapDistance;

@end


@implementation CommentsPopView

- (instancetype)initWithSmallVideoModel:(KB_HomeVideoDetailModel *)smallVideoModel {
    self = [super init];
    if (self) {
        self.isDragTableView = NO;
        self.lastDrapDistance = 0.0;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor =  [UIColor clearColor];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)];
        self.tapGestureRecognizer = tapGestureRecognizer;
        tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tapGestureRecognizer];
        
        self.videoModel = smallVideoModel;
//        _pageIndex = 0;
//        _pageSize = 20;
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * 3 / 4)];
        _container.backgroundColor = [UIColor clearColor];//ColorBlackAlpha60;
        [self addSubview:_container];
        
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:_container.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f , 10.0f )];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        _container.layer.mask = shape;
        
       
        UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualEffectView.frame = self.bounds;
        visualEffectView.alpha = 1.0f;
        [_container addSubview:visualEffectView];
        
        self.numCommentLabel = [[UILabel alloc] init];
        self.numCommentLabel.textColor = [UIColor blackColor];//ColorGray;
        self.numCommentLabel.text = [NSString stringWithFormat:@"%@条评论",@(self.videoModel.status)];
        self.numCommentLabel.font = [UIFont systemFontOfSize:14];//SmallFont;
        self.numCommentLabel.textAlignment = NSTextAlignmentCenter;
        [_container addSubview:self.numCommentLabel];
        [self.numCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.container);
            make.height.mas_equalTo(35  );
        }];
        @weakify(self);
        [RACObserve(self, videoModel.status) subscribeNext:^(NSNumber *x) {
            @strongify(self);
            self.numCommentLabel.text = [NSString stringWithFormat:@"%ld条评论",(long)x.integerValue];
        }];
        
        
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setBackgroundImage:[UIImage imageNamed: @"smallVideo_close_comment"] forState:UIControlStateNormal] ;
        _closeBtn.contentMode = UIViewContentModeCenter;
//        [_closeBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_container addSubview:_closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.numCommentLabel);
            make.right.equalTo(self.numCommentLabel).with.offset(-10  );
            make.width.height.mas_equalTo(15  );
        }];
//        [_closeBtn setEnlargeEdgeWithTop:10   right:10   bottom:10   left:10  ];
        
        _commentTextView = [CommentTextView new];
        _commentTextView.delegate = self;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35 , SCREEN_WIDTH, _container.height - 35   - _commentTextView.container.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if(@available(iOS 11.0, *)){
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.estimatedRowHeight = 150  ;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CommentMessageCell class] forCellReuseIdentifier:commentMessageCellIdentifier];
        [_container addSubview:_tableView];
        //添加拖拽手势
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self.container addGestureRecognizer:self.panGestureRecognizer];
        self.panGestureRecognizer.delegate = self;
        [self getData];
    }
    return self;
}

#pragma mark - 根据videoId加载评论
- (void)getData {
    [RequesetApi requestAPIWithParams:nil andRequestUrl:[NSString stringWithFormat:@"/video/queryCommentsByVideoId?videoId=%@",self.videoModel.id] completedBlock:^(ApiResponseModel *apiResponseModel, BOOL isSuccess) {
        if (isSuccess) {
            //请求成功
            NSMutableArray *datas = [NSArray modelArrayWithClass:[CommentModel class] json:apiResponseModel.data].mutableCopy;
            if (datas.count) {
                self.hotCommentArray = datas;
                [self.tableView reloadData];
            }else {
                [SVProgressHUD showErrorWithStatus:@"加载失败"];
            }
        } else {
            //请求失败
            
        }
    }];
}


#pragma mark - Action

//update method
- (void)showToView:(UIView *)view {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [view addSubview:self];
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y - frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                     }];
    [self.commentTextView showToView:window];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y + frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [self.commentTextView dismiss];
                     }];
}

#pragma mark 发送评论
- (void)sendComment {
//    [self textView:self.commentTextView.textView shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:@"\n"];
}


#pragma mark - UIGestureRecognizerDelegate
//1
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //    if([gestureRecognizer isKindOfClass:[UIGestureRecognizer class]]) {
    //        CGPoint point = [gestureRecognizer locationInView:_container];
    //        DLog(@"%@",NSStringFromCGPoint(point));
    //    }
    if(gestureRecognizer == self.panGestureRecognizer) {
        UIView *touchView = touch.view;
        while (touchView != nil) {
            if(touchView == self.tableView) {
                self.isDragTableView = YES;
                break;
            } else if(touchView == self.container) {
                self.isDragTableView = NO;
                break;
            }
            touchView = [touchView nextResponder];
        }
        DLog(@"shouldReceiveTouch");
    }
    return YES;
}

//2.
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer == self.tapGestureRecognizer) {
        //如果是点击手势
        CGPoint point = [gestureRecognizer locationInView:_container];
        if([_container.layer containsPoint:point] && gestureRecognizer.view == self) {
            return NO;
        }
    } else if(gestureRecognizer == self.panGestureRecognizer){
        //如果是自己加的拖拽手势
        DLog(@"gestureRecognizerShouldBegin");
    }
    return YES;
}

//3. 是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    DLog(@"shouldRecognizeSimultaneouslyWithGestureRecognizer :\n%@  \n%@  \n%@",self.panGestureRecognizer,gestureRecognizer,otherGestureRecognizer);
    if(gestureRecognizer == self.panGestureRecognizer) {
        if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")] ) {
            if(otherGestureRecognizer.view == self.tableView) {
//                self.isDragTableView = YES;
//                CGPoint translationLog = [gestureRecognizer translationInView:gestureRecognizer.view];
//                //如果是往下滑并且self.tableView置于顶端
//                if(translationLog.y > 0 && self.tableView.contentOffset.y <= 0) {
//                    otherGestureRecognizer.enabled = NO;
//                    otherGestureRecognizer.enabled = YES;
//                }
                return YES;
            }
            
        }
    }
    return NO;
}

//拖拽手势
- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 获取手指的偏移量
    CGPoint transP = [panGestureRecognizer translationInView:self.container];
    NSLog(@"transP : %@",NSStringFromCGPoint(transP));
    CGPoint transP2 = [panGestureRecognizer translationInView:self.tableView];
    NSLog(@"transP2 : %@",NSStringFromCGPoint(transP2));
    if(self.isDragTableView) {
        //如果当前拖拽的是tableView
        if(self.tableView.contentOffset.y <= 0) {
            //如果tableView置于顶端
            if(transP.y > 0) {
                //如果向下拖拽
                self.tableView.contentOffset = CGPointMake(0, 0 );
                self.tableView.panGestureRecognizer.enabled = NO;
                self.tableView.panGestureRecognizer.enabled = YES;
                self.isDragTableView = NO;
                //向下拖
                self.container.frame = CGRectMake(self.container.left, self.container.top + transP.y, self.container.width, self.container.height);
            } else {
                //如果向上拖拽
            }
        }
    } else {
        if(transP.y > 0) {
            //向下拖
            self.container.frame = CGRectMake(self.container.left, self.container.top + transP.y, self.container.width, self.container.height);
        } else if(transP.y < 0 && self.container.top > (SCREEN_HEIGHT - self.container.height)){
            //向上拖
            self.container.frame = CGRectMake(self.container.left, (self.container.top + transP.y) > (SCREEN_HEIGHT - self.container.height) ? (self.container.top + transP.y) : (SCREEN_HEIGHT - self.container.height), self.container.width, self.container.height);
        } else {
            
        }
    }
    
    [panGestureRecognizer setTranslation:CGPointZero inView:self.container];
    if(panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"transP : %@",NSStringFromCGPoint(transP));
        NSLog(@"transP2 : %@",NSStringFromCGPoint(transP2));
        if(self.lastDrapDistance > 10 && self.isDragTableView == NO) {
            //如果是类似轻扫的那种
            [self dismiss];
        } else {
            //如果是普通拖拽
            if(self.container.top >= SCREEN_HEIGHT - self.container.height/2) {
                [self dismiss];
            } else {
                [UIView animateWithDuration:0.15f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     self.container.top = SCREEN_HEIGHT - self.container.height;
                                 }
                                 completion:^(BOOL finished) {
                                     DLog(@"结束");
                                 }];
                
            }
        }
    }
    self.lastDrapDistance = transP.y;
    
}

//点击手势
- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    
    CGPoint point = [sender locationInView:_container];
    if(![_container.layer containsPoint:point] && sender.view == self) {
        [self dismiss];
        return;
    }
    //    point = [sender locationInView:_close];
    //    if([_close.layer containsPoint:point]) {
    //        [self dismiss];
    //    }
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    DLog(@"scrollViewDidScroll  %@",NSStringFromCGPoint( [scrollView.panGestureRecognizer translationInView:self.tableView]));
////    if(scrollView.tracking == YES) {
////
////    }
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.hotCommentArray.count;
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *model = self.hotCommentArray[indexPath.row];
    CommentMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:commentMessageCellIdentifier];
    cell.delegate = self;
    cell.commentModel = model;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}



#pragma mark - CommentTextViewDelegate
-(void)onSendText:(NSString *)text {
   
    //提交评论
//    [self requestWithAddComment];
    CommentModel *model = [[CommentModel alloc] init];
    model.nickName = User_Center.nickname;
    model.id = @(self.hotCommentArray.count + 1).stringValue;
    model.comment = self.commentTextView.textView.text;
    long long timeStr = [NSDate getNowTimestampStringLevelMilliSecond].longLongValue;
    model.createTime = [@(timeStr).stringValue dateStringUseWeChatFormatSinceNow];
    model.head_url = User_Center.faceImage;
    [self.hotCommentArray insertObject:model atIndex:0];
    
    self.commentTextView.textView.text = @"";
    self.commentTextView.placeholderLabel.text = @"说点什么...";
    
    [self.tableView reloadData];
    
}



#pragma mark - lazyLoad


- (NSMutableArray *)hotCommentArray {
    if(!_hotCommentArray) {
        _hotCommentArray = [NSMutableArray array];
    }
    return _hotCommentArray;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}


@end









