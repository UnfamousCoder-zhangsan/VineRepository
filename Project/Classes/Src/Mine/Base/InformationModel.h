//
//  InformationModel.h
//  Project
//
//  Created by hi  kobe on 2020/4/18.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InformationModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *faceImage;
@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, assign) NSInteger fansCounts;
@property (nonatomic, assign) NSInteger followCounts;
@property (nonatomic, assign) NSInteger receiveLikeCounts;
@end

NS_ASSUME_NONNULL_END
