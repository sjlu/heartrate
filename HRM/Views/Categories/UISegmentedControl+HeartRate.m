//
//  UISegmentedControl+HeartRate.m
//  heartrate
//
//  Created by Jonathan Grana on 11/28/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "UISegmentedControl+HeartRate.h"
#import "UIColor+HeartRate.h"

@implementation UISegmentedControl (HeartRate)

+ (instancetype)defaultSegmentedControlWithItems:(NSArray *)items {
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:items];
    segment.tintColor = [UIColor whiteColor];
    return segment;
}

@end
