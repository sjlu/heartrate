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
static NSString * const kWeightKey = @"Weight";
static NSString * const kHeightKey = @"Height";
static NSString * const kGenderKey = @"Gender";

+ (NSNumber *)getAge {
    return (NSNumber *)[self _getValueForKey:kAgeKey];
}

+ (void)setAge:(NSNumber *)age {
    [self _setValue:age forKey:kAgeKey];
}

+ (NSNumber *)getWeight {
    return (NSNumber *)[self _getValueForKey:kWeightKey];
}

+ (void)setWeight:(NSNumber *)weight {
    [self _setValue:weight forKey:kWeightKey];
}

+ (NSNumber *)getHeight {
    return (NSNumber *)[self _getValueForKey:kHeightKey];
}

+ (void)setHeight:(NSNumber *)height {
    [self _setValue:height forKey:kHeightKey];
}

+ (NSString *)getGender {
    return (NSString *)[self _getValueForKey:kGenderKey];
}

+ (void)setGender:(NSString *)gender {
    [self _setValue:gender forKey:kGenderKey];
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
