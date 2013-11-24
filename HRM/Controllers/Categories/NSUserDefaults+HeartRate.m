//
//  NSUserDefaults+HeartRate.m
//  heartrate
//
//  Created by Jonathan Grana on 11/23/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "NSUserDefaults+HeartRate.h"

@implementation NSUserDefaults (HeartRate)

static NSString * const kAgeKey = @"Age";

+ (NSNumber *)getAge {
    return (NSNumber *)[self _getValueForKey:kAgeKey];
}

+ (void)setAge:(NSNumber *)age {
    [self _setValue:age forKey:kAgeKey];
}

+ (NSNumber *)getMaxHeartRate {
    return [NSNumber numberWithInteger:220 - self.getAge.integerValue];
}

+ (NSObject *)_getValueForKey:(NSString *)key {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSAssert(standardUserDefaults, @"Expected standardUserDefaults");
    return [standardUserDefaults valueForKey:key];
}

+ (void)_setValue:(NSObject *)value forKey:(NSString *)key {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSAssert(standardUserDefaults, @"Expected standardUserDefaults");
    [standardUserDefaults setObject:value
                             forKey:key];
    [standardUserDefaults synchronize];
}

@end
