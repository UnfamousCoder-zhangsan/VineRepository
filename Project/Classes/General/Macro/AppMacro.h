//
//  ServerDefine.h
//  PublicLawyerChat
//
//  Created by lawchat on 16/5/6.
//  Copyright © 2016年 李庆. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#import "ColorMacro.h"

//  自定义更详细的Log
#ifdef DEBUG
#define LQLog(fmt, ...) NSLog((@"%s [Line %d] 🐔🐔🐔:" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define LQLog(...)
#endif

// 颜色值RGB
#define RGBA(r,g,b,a)                       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGBCOLORVALUE(rgb)      UIColorFromRGBValue((rgb))
//是否是iPhoneX
#define kDevice_Is_iPhoneX (@available(iOS 11.0, *) ? ([UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom ? YES : NO) : NO)
#define SafeAreaBottomHeight (@available(iOS 11.0, *) ? [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom : 0)
#define SafeAreaTopHeight (@available(iOS 11.0, *) ? [UIApplication sharedApplication].keyWindow.safeAreaInsets.top : 0)
#define SafeAreaLeftHeight (@available(iOS 11.0, *) ? [UIApplication sharedApplication].keyWindow.safeAreaInsets.left : 0)
#define SafeAreaRightHeight (@available(iOS 11.0, *) ? [UIApplication sharedApplication].keyWindow.safeAreaInsets.right : 0)


#define DLog(format, ...) printf("\n %s [第%d行] %s\n",  __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);

//系统
#define kiOS10 ([UIDevice systemVersion] >= 10 || [UIDevice systemVersion] < 11)
#define kiOS11 ([UIDevice systemVersion] >= 11 || [UIDevice systemVersion] < 12)
#define kiOS12 ([UIDevice systemVersion] >= 12 || [UIDevice systemVersion] < 13)
#define kiOS13 ([UIDevice systemVersion] >= 13)


/// 应用版本号
#define App_Version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/************* 单例宏 ****************/
#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define kSharedApplication [UIApplication sharedApplication]
#define kAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]
/************* 单例宏 ****************/

#endif /* ServerDefine_h */
