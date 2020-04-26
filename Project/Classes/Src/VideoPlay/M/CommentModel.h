//
//  CommentModel.h
//  Project
//
//  Created by hi  kobe on 2020/4/7.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentModel : NSObject

//当前的评论ID
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *videoId;
//当前评论内容
@property(nonatomic, copy) NSString *comment;
@property(nonatomic, copy) NSString *fromUserId;
//当前评论日期
@property(nonatomic, strong) NSString *createTime;

//当前评论人名字
@property(nonatomic, strong) NSString *nickName;
//当前评论人头像地址
@property(nonatomic, strong) NSString *head_url;
@property(nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
