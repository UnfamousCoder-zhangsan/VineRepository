//
//  AppDelegate.h
//  PublicLawyerChat
//
//  Created by  jackli on 15/5/20.
//  Copyright (c) 2015   jackli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件文件

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) BMKMapManager *mapManager;
@end

