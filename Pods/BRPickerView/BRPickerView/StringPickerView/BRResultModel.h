//
//  BRResultModel.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2019/10/2.
//  Copyright © 2019年 91renb. All rights reserved.
//
//  最新代码下载地址：https://github.com/91renb/BRPickerView

#import <Foundation/Foundation.h>
#import "BRPickerViewMacro.h"

@interface BRResultModel : NSObject
/** 父级ID */
@property (nonatomic, copy) NSString *ParentID;
/** ID */
@property (nonatomic, copy) NSString *ID;
/** key */
@property (nonatomic, copy) NSString *key;
/** 值 */
@property (nonatomic, copy) NSString *value;
/** 备注 */
@property (nonatomic, copy) NSString *remark;

/** 选择值对应的索引（行数） */
@property (nonatomic, assign) NSInteger index;

/** 值 */
@property (nonatomic, copy) NSString *name BRPickerViewDeprecated("请使用 value");
/** 选择的值 */
@property (nonatomic, copy) NSString *selectValue BRPickerViewDeprecated("请使用 value");

@end
