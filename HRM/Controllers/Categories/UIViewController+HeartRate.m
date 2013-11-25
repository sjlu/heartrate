//
//  UIViewController+HeartRate.m
//  heartrate
//
//  Created by Jonathan Grana on 11/24/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "UIViewController+HeartRate.h"

@implementation UIViewController (HeartRate)

- (void)setTintColor:(UIColor *)tintColor {
    WEAK(self);
    [UIView animateWithDuration:1.f
                     animations:^{
                         weak_self.navigationController.navigationBar.tintColor = tintColor;
                         [self updateSubview:weak_self.view.subviews tintColor:tintColor];
                         [self updateSubview:weak_self.navigationController.navigationBar.subviews tintColor:tintColor];
                         
                         for(UIViewController *child in self.childViewControllers) {
                             child.tintColor = tintColor;
                         }
                         
                         for(UIViewController *child in self.childViewControllers) {
                             child.tintColor = tintColor;
                         }
                     }];
}

-(void)updateSubview:(NSArray *)subviews tintColor:(UIColor *)tintColor {
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            label.textColor = tintColor;
        }
        else if ([subview isKindOfClass:[UIImageView class]]) {
            UIImageView *image = (UIImageView *)subview;
            image.tintColor = tintColor;
        }
        else if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *field = (UITextField *)subview;
            field.textColor = tintColor;
        }
        else {
            subview.tintColor = tintColor;
            if (subview.subviews.count < 1) {
                subview.backgroundColor = tintColor;
            }
        }
            [self updateSubview:subview.subviews tintColor:tintColor];
    }
}

@end
