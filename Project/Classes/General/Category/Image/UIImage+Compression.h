//
//  UIImage+Compression.h
//  CompressionImg
//
//  Created by Eli on 2019/1/24.
//  Copyright © 2019 Ely. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage(Compression)


/// 压缩图片，返回压缩后的UIimage
- (UIImage *)compressToImage;
/// 压缩图片，返回压缩后的数据
- (NSData *)compressToData;
@end

NS_ASSUME_NONNULL_END
