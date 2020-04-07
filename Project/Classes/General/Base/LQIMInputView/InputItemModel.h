//
//  InputItemModel.h
//  LQIMInputView
//
//  Created by lawchat on 2016/10/25.
//  Copyright © 2016年 674297026@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, InputItemModelType)
{
    InputItemModelType_Default = 0,//
    InputItemModelType_Pay = 1//
 
};

@interface InputItemModel : NSObject

@property(nonatomic,strong) NSString *title;

@property(nonatomic,strong) NSString *imageName;

@property(nonatomic,assign) InputItemModelType inputItemModelType;

typedef void (^ItemClicked)(void);
@property(nonatomic, copy) ItemClicked clickedBlock;


+ (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName clickedBlock:(ItemClicked)clickedBlock;

+ (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName type:(InputItemModelType)inputItemModelType clickedBlock:(ItemClicked)clickedBlock;
@end
