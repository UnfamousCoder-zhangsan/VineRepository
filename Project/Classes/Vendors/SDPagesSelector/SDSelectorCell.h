//
//  SDSelectorCell.h
//  SDPagesSelector
//
//  Created by 宋东昊 on 16/7/15.
//  Copyright © 2016年 songdh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDSelectorCell : UICollectionViewCell

-(void)setItemSelected:(BOOL)selected;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *normalImage;

@property (nonatomic, copy) NSString *selectedImage;

/**
 *  默认分别是 [UIColor redColor],[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *normalColor;

/**
 *  默认都是14号字体
 */
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIFont *normalFont;

@end
