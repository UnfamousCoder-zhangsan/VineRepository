//
//  KB_MessageListVC.h
//  Project
//
//  Created by hikobe on 2020/5/19.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, CellType)
{
    CellType_Fan = 0,//
    CellType_Like = 1,//
    CellType_Comment = 2
};

@interface KB_MessageListVC : QDCommonTableViewController
@property(nonatomic, assign) CellType type;

@end

NS_ASSUME_NONNULL_END
