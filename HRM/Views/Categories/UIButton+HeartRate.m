//
//  UIButton+HeartRate.m
//  heartrate
//
//  Created by Jonathan Grana on 11/28/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "UIButton+HeartRate.h"

#import "UIImage+Factory.h"
#import "UILabel+HeartRate.h"
#import "UIColor+HeartRate.h"

@implementation UIButton (HeartRate)

+ (UIButton *)defaultButtonWithFrame:(CGRect)frame andTitle:(NSString *)title {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]
                                          cornerRadius:0.f]
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]
                                          cornerRadius:0.f]
                      forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor heartRateRed]
                 forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel applyDefaultStyleWithSize:24.f];
    return button;
}

@end
