//
//  KB_HomeVideoDetailModel.h
//  Project
//
//  Created by hi  kobe on 2020/4/15.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KB_HomeVideoDetailModel : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *audioId;
@property (nonatomic, strong) NSString *videoDesc;
@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) NSString *videoCategory;
@property (nonatomic, assign) float     videoSeconds;
@property (nonatomic, assign) CGFloat   videoWidth;
@property (nonatomic, assign) CGFloat   videoHeight;
@property (nonatomic, strong) NSString *coverPath;
@property (nonatomic, assign) NSInteger likeCounts;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *face_image;
@property (nonatomic, strong) NSString *videoFilter;
@property (nonatomic, assign) BOOL      isFoucs;
@property(nonatomic, assign) BOOL       isLike;
@end

NS_ASSUME_NONNULL_END
