//
//  AppDelegate.h
//  Vines
//
//  Created by hi  kobe on 2020/3/21.
//  Copyright © 2020 hi  kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

