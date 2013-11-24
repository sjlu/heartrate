//
//  NSUserDefaults+HeartRate.h
//  heartrate
//
//  Created by Jonathan Grana on 11/23/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (HeartRate)

+ (NSNumber *)getAge;
+ (void)setAge:(NSNumber *)age;

+ (NSNumber *)getMaxHeartRate;

@end
