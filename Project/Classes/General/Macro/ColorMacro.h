//
//  ColorMacro.h
//  Project
//
//  Created by ChesterLee on 2019/11/15.
//  Copyright © 2019 64365. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h

/// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

//应用中常用颜色
#define APPColor_BackgroudView UIColorFromRGB(0x222222)

/// 可操作色 蓝色)
#define APPColor_Blue [UIColor colorWithRed:54.0f / 255.0f green:130.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f]
/// 主题 (绿色)
#define APPColor_Green UIColorFromRGB(0x1AC095)
/// 警示色（红色）
#define APPColor_Red UIColorFromRGB(0xE6484E)
/// 警告色（橙色）
#define APPColor_Orange UIColorFromRGB(0xFE834B)

#define APPColor_ThemeBlue UIColorFromRGB(0x404e8a)

//文本色（不同灰度色）
#define APPColor_222 UIColorFromRGB(0x222222)
#define APPColor_333 UIColorFromRGB(0x333333)
#define APPColor_666 UIColorFromRGB(0x666666)
#define APPColor_999 UIColorFromRGB(0x999999)
#define APPColor_BBB UIColorFromRGB(0xBBBBBB)
#define APPColor_DDD UIColorFromRGB(0xDDDDDD)
#define APPColor_888 UIColorFromRGB(0x888888)
#define APPColor_CCC UIColorFromRGB(0xCCCCCC)
#define APPColor_35 UIColorFromRGB(0x353535)
#define APPColor_555 UIColorFromRGB(0x555555)
#define APPColor_F2 UIColorFromRGB(0xF2F2F2)
#define APPColor_AAA UIColorFromRGB(0xAAAAAA)
#define APPColor_EEE UIColorFromRGB(0xEEEEEE)
#define APPColor_F9 UIColorFromRGB(0xF9F9F9)
#define APPColor_B2 UIColorFromRGB(0xB2B2B2)
#define APPColor_E6 UIColorFromRGB(0xE6E6E6)
#define APPColor_E0 UIColorFromRGB(0xE0E0E0)

#endif /* ColorMacro_h */
