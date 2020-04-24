//
//  KB_CountDownLabel.m
//  Project
//
//  Created by hikobe on 2020/4/24.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "KB_CountDownLabel.h"


#define WZBScreenWidth [UIScreen mainScreen].bounds.size.width
#define WZBScreenHeight [UIScreen mainScreen].bounds.size.height
#define WZBAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))
#define WZBFontSize WZBScreenWidth/414
#define WZBFont(size) [UIFont boldSystemFontOfSize:(size * WZBFontSize)]
#define WZBSetWidth(frame, w) frame = CGRectMake(frame.origin.x, frame.origin.y, w, frame.size.height)
#define WZBStringWidth(string, font) [label.endTitle sizeWithAttributes:@{NSFontAttributeName : font}].width
@interface KB_CountDownLabel()
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString *endTitle;
@property (nonatomic, copy) CountdownSuccessBlock countdownSuccessBlock;
@property (nonatomic, copy) CountdownBeginBlock countdownBeginBlock;
@end

@implementation KB_CountDownLabel
static BOOL isAnimationing;

+ (instancetype)share {
    static KB_CountDownLabel *label = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        label = [[KB_CountDownLabel alloc] init];
        isAnimationing = NO;
    });
    return label;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        isAnimationing = NO;
    }
    return self;
}

+ (void)hidden {
    isAnimationing = NO;
    // 复原label状态，这句话必须写，不然又问题
    [KB_CountDownLabel share].transform = CGAffineTransformIdentity;
    [KB_CountDownLabel share].hidden = YES;
}

+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle begin:(CountdownBeginBlock)begin success:(CountdownSuccessBlock)success {
    // isAnimationing 用来判断目前是否在动画
    if (isAnimationing) return nil;
    KB_CountDownLabel *label = [KB_CountDownLabel share];
    label.hidden = NO;
    // 给全局属性赋值
    // 默认三秒
    label.number = 3;
    if (number && number > 0) label.number = number;
    if (endTitle) label.endTitle = endTitle;
    if (success) label.countdownSuccessBlock = success;
    if (begin) label.countdownBeginBlock = begin;
    
    [self setupLabelBase:label];
    
    // 动画倒计时部分
    [self scaleActionWithBeginBlock:begin andSuccessBlock:success label:label];
    return label;
}

+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle success:(CountdownSuccessBlock)success{
    return [self playWithNumber:number endTitle:endTitle begin:[KB_CountDownLabel share].countdownBeginBlock success:success];
}

// label的基本属性
+ (void)setupLabelBase:(KB_CountDownLabel *)label {
    label.frame = (CGRect){0, 0, 50, WZBScreenWidth};
    label.transform = CGAffineTransformScale(label.transform, 10, 10);
    label.alpha = 0;
    label.text = [NSString stringWithFormat:@"%zd", label.number];
    label.textColor = UIColorMakeWithHex(@"#FFFFFF");
    label.font = WZBFont(20.0f);
//    WZBSetWidth(label.frame, WZBStringWidth(label.endTitle, label.font));
    [[label getCurrentView] addSubview:label];
    label.center = CGPointMake(WZBScreenWidth / 2, WZBScreenHeight / 2);
    label.textAlignment = NSTextAlignmentCenter;
}

// 动画倒计时部分
+ (void)scaleActionWithBeginBlock:(CountdownBeginBlock)begin andSuccessBlock:(CountdownSuccessBlock)success label:(KB_CountDownLabel *)label {
    if (!isAnimationing) { // 如果不在动画才走开始的代理和block
        if (begin) begin(label);
        if ([label.delegate respondsToSelector:@selector(countdownBegin:)]) [label.delegate countdownBegin:label];
    }
    // 这个判断用来表示有没有结束语
    if (label.number >= (label.endTitle ? 0 : 1)) {
        isAnimationing = YES;
        label.text = label.number == 0 ? label.endTitle : [NSString stringWithFormat:@"%zd", label.number];
        [UIView animateWithDuration:1 animations:^{
            label.transform = CGAffineTransformIdentity;
            label.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished) {
                label.number--;
                label.alpha = 0;
                label.transform = CGAffineTransformScale(label.transform, 10, 10);
                [self scaleActionWithBeginBlock:begin andSuccessBlock:success label:label];
            }
        }];
    } else {
        // 调用倒计时完成的代理和block
        if ([label.delegate respondsToSelector:@selector(countdownSuccess:)]) [label.delegate countdownSuccess:label];

        if (success) success(label);
        [self hidden];
    }
}

// 拿到当前显示的控制器的View。不建议直接放到window上，这样的话，如果倒计时不结束视图就跳转，倒计时不会停止移除
- (UIView *)getCurrentView {
    return [self getVisibleViewControllerFrom:(UIViewController *)WZBAppDelegate.window.rootViewController].view;
}

/// 这个方法是拿到当前正在显示的控制器，不管是push进去的，还是present进去的都能拿到，相信很多项目会用到。拿去不谢！
- (UIViewController *)getVisibleViewControllerFrom:(UIViewController*)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController*) vc) visibleViewController]];
    }else if ([vc isKindOfClass:[UITabBarController class]]){
        return [self getVisibleViewControllerFrom:[((UITabBarController*) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

#pragma mark - play methods
+ (instancetype)play {
    return [self playWithNumber:0];
}

+ (instancetype)playWithNumber:(NSInteger)number {
    return [self playWithNumber:number endTitle:[KB_CountDownLabel share].endTitle];
}

+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle {
    return [self playWithNumber:number endTitle:endTitle success:[KB_CountDownLabel share].countdownSuccessBlock];
}

+ (instancetype)playWithNumber:(NSInteger)number success:(CountdownSuccessBlock)success {
    return [self playWithNumber:number endTitle:[KB_CountDownLabel share].endTitle success:success];
}

#pragma mark - add block
+ (void)addCountdownSuccessBlock:(CountdownSuccessBlock)success {
    [KB_CountDownLabel share].countdownSuccessBlock = success;
}

+ (void)addCountdownBeginBlock:(CountdownBeginBlock)begin {
    [KB_CountDownLabel share].countdownBeginBlock = begin;
}

+ (void)addCountdownBeginBlock:(CountdownBeginBlock)begin successBlock:(CountdownSuccessBlock)success {
    [KB_CountDownLabel share].countdownSuccessBlock = success;
    [KB_CountDownLabel share].countdownBeginBlock = begin;
}

#pragma mark - add delegate
+ (void)addDelegate:(id<KBCountdownLabelDelegate>)delegate {
    [KB_CountDownLabel share].delegate = delegate;
}


@end
