//
//  HeartRateContainer.m
//  heartrate
//
//  Created by Jonathan Grana on 11/24/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "HeartRateContainer.h"

@implementation HeartRateContainer

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            label.textColor = tintColor;
        }
        else if ([subview isKindOfClass:[UIImageView class]]) {
            UIImageView *image = (UIImageView *)subview;
            image.tintColor = tintColor;
        }
//        else {
//            subview.backgroundColor = tintColor;
//        }
    }
}

@end
