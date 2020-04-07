//
//  SmallVideoModel.h
//  Project
//
//  Created by hi  kobe on 2020/4/7.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SmallVideoModel : NSObject

@property (nonatomic)        UInt64      rid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger comment_num;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *head_url;
@property (nonatomic, copy) NSString *video_url;
@property (nonatomic, copy) NSString *cover_url;
@property (nonatomic, assign) CGFloat aspect;

@end

NS_ASSUME_NONNULL_END
