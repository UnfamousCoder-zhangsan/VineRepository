//
//  AppConst.h
//  LawChatForLawyer
//
//  Created by Juice on 2017/7/7.
//  Copyright © 2017年 就问律师. All rights reserved.
//

#ifndef AppConst_h
#define AppConst_h

#import "NotifycationConst.h"

#import "PushConst.h"


/// 客服服务电话
static NSString *const kServiceTel = @"123456789";

/// 图片访问地址
#ifdef DEBUG
static NSString *const kImageSrcUpLoadUrl = @"http://file.hii-m.itranlin.com";
static NSString *const kImageSrcUrl = @"http://dowmload.hii-m.itranlin.com";
#else
static NSString *const kImageSrcUpLoadUrl = @"http://47.111.169.178:9999";
static NSString *const kImageSrcUrl = @"http://47.111.169.178:8888";
#endif

/// 上架bundleID: com.zhangshangtong.ryy  对应百度map
static NSString *const kBaiDuMapAK = @"h4QHlTkAS1HKDg2sxoHbabmfNlMC7Ysp";

/// 测试bundleID: com.LQProject.zhangshangtong  对应百度map
//static NSString *const kBaiDuMapAK = @"O1BBfzHkOZ1CdmWNIbHslISf8jTs22ZU";

#endif /* AppConst_h */
