//
//  UITableViewCell+sectionCell.h
//  Project
//
//  Created by xiexi on 2020/1/20.
//  Copyright © 2020 674297026@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (sectionCell)
-(void)backgroundViewWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cornerRadius:(CGFloat)cornerRadius bounds:(CGRect)bounds needSeparate:(BOOL)needSeparate;
@end

NS_ASSUME_NONNULL_END
