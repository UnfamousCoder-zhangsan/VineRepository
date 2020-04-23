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

/// 微信appkey
static NSString *const WxAppKey = @"wxbdcc8de8ed2a1110";
/// 微信appsecret
static NSString *const WxAppSecret = @"46ed43a3c8647ffd4e181a088c9d5f29";

/// 上架bundleID: com.zhangshangtong.ryy  对应百度map
static NSString *const kBaiDuMapAK = @"h4QHlTkAS1HKDg2sxoHbabmfNlMC7Ysp";

/// 服务器地址
static NSString *const kAddressUrl = @"https://www.lotcloudy.com/scetc-show-videos-mini-api-0.0.1-SNAPSHOT/";

#endif /* AppConst_h */
