//
//  UITextField+HeartRate.m
//  heartrate
//
//  Created by Jonathan Grana on 11/23/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "UITextField+HeartRate.h"

#import "UIColor+HeartRate.h"
#import "UIImage+Factory.h"

@implementation UITextField (HeartRate)

- (void)applyDefaultStyleWithSize:(CGFloat)size {
    self.textColor = [UIColor heartRateRed];
    self.background = [UIImage imageWithColor:[UIColor whiteColor] cornerRadius:5.f];
    self.borderStyle = UITextBorderStyleNone;
    self.font = [UIFont fontWithName:@"Avenir" size:size];
    self.textAlignment = NSTextAlignmentCenter;
}

@end
