//
//  KB_CountDownLabel.h
//  Project
//
//  Created by hikobe on 2020/4/24.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KBCountDownType) {
    KBCountDownNumber = 0,
    KBCountDownString
};
@class KB_CountDownLabel;

// delegate
@protocol KBCountdownLabelDelegate <NSObject>

@optional
//** 倒计时完成时调用 */
- (void)countdownSuccess:(KB_CountDownLabel *)label;

//** 倒计时开始时调用 */
- (void)countdownBegin:(KB_CountDownLabel *)label;
@end

//** 倒计时完成时调的block */
typedef void(^CountdownSuccessBlock)(KB_CountDownLabel *label);
//** 倒计时开始时调的block */
typedef void(^CountdownBeginBlock)(KB_CountDownLabel *label);

@interface KB_CountDownLabel : UILabel

//** delegate */
@property (nonatomic, weak) id<KBCountdownLabelDelegate> delegate;
//** 隐藏 */
+ (void)hidden;
//** 全是默认值的play方法 */
+ (instancetype)play;

//** number : 倒计时开始数字 */
+ (instancetype)playWithNumber:(NSInteger)number;
//** number : 倒计时开始数字；endTitle : 倒计时结束时显示的字符 */
+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle;
//** number : 倒计时开始数字；success : 倒计时完成回调 */
+ (instancetype)playWithNumber:(NSInteger)number success:(CountdownSuccessBlock)success;
//** number : 倒计时开始数字；endTitle : 倒计时结束时显示的字符；success : 倒计时完成回调； */
+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle success:(CountdownSuccessBlock)success;
//** number : 倒计时开始数字；endTitle : 倒计时结束时显示的字符；begin : 倒计时开始回调；success : 倒计时完成回调；*/
+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle begin:(CountdownBeginBlock)begin success:(CountdownSuccessBlock)success;

//** 绑定代理 */
+ (void)addDelegate:(id<KBCountdownLabelDelegate>)delegate;
//** 倒计时完成时的block监听 */
+ (void)addCountdownSuccessBlock:(CountdownSuccessBlock)success;
//** 倒计时开始时的block监听 */
+ (void)addCountdownBeginBlock:(CountdownBeginBlock)begin;
//** 倒计时开始时和结束时的block监听 */
+ (void)addCountdownBeginBlock:(CountdownBeginBlock)begin successBlock:(CountdownSuccessBlock)success;

@end
