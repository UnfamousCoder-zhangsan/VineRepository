//
//  MessageListModel.h
//  Project
//
//  Created by hikobe on 2020/5/19.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageListModel : NSObject
@property(nonatomic, strong) NSString *headerUrl;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *comment;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, assign) long long time;
@end

NS_ASSUME_NONNULL_END
