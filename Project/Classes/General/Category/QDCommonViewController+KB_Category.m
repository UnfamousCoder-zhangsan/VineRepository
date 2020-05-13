//
//  QDCommonViewController+KB_Category.m
//  Project
//
//  Created by hikobe on 2020/5/13.
//  Copyright © 2020 hiKobe@lsirCode. All rights reserved.
//

#import "QDCommonViewController+KB_Category.h"

@implementation QDCommonViewController (KB_Category)

static char kAssociatedObjectKey_navBarAlpha;

- (void)setKb_navBarAlpha:(CGFloat)kb_navBarAlpha{
    objc_setAssociatedObject(self, &kAssociatedObjectKey_navBarAlpha, @(kb_navBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.navigationController.navigationBar.alpha = kb_navBarAlpha;
}

- (CGFloat)kb_navBarAlpha{
    id obj = objc_getAssociatedObject(self, &kAssociatedObjectKey_navBarAlpha);
    return obj ? [obj floatValue] : 1.0f;
}

static char kAssociatedObjectKey_navBackgroundImage;
- (void)setKb_navBackgroundImage:(UIImage *)kb_navBackgroundImage{
    objc_setAssociatedObject(self, &kAssociatedObjectKey_navBackgroundImage, kb_navBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self.navigationController.navigationBar setBackgroundImage:kb_navBackgroundImage forBarMetrics:UIBarMetricsDefault];
}

- (UIImage *)kb_navBackgroundImage{
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_navBackgroundImage);
}
@end
