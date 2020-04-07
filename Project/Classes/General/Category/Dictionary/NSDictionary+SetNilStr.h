//
//  NSDictionary+SetNilStr.h
//  Project
//
//  Created by 李庆 on 2020/2/6.
//  Copyright © 2020 674297026@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (SetNilStr)
/*
*把服务器返回的<null> 替换为“”
*json表示获取到的带有NULL对象的json数据
*NSDictionary *newDict = [NSDictionary changeType:json];
*/
+(id)changeType:(id)myObj;
@end

NS_ASSUME_NONNULL_END
