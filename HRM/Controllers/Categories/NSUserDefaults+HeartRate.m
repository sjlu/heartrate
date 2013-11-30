//
//  NSUserDefaults+HeartRate.m
//  heartrate
//
//  Created by Jonathan Grana on 11/23/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "NSUserDefaults+HeartRate.h"

@implementation NSUserDefaults (HeartRate)

static NSString * const kWeightKey = @"Weight";
static NSString * const kHeightKey = @"Height";
static NSString * const kGenderKey = @"Gender";
static NSString * const kWeightUnitKey = @"WeightUnit";
static NSString * const kBirthdayKey = @"Birthday";

+ (NSDate *)getBirthday {
    return (NSDate *)[self _getValueForKey:kBirthdayKey];
}

+ (void)setBirthday:(NSDate *)birthday {
    [self _setValue:birthday forKey:kBirthdayKey];
}

+ (NSNumber *)getAge {
    NSDate *birthday = [self getBirthday];
    if (birthday) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:birthday];
        return [NSNumber numberWithInt:interval / 31536000];
    }
    return nil;
}

+ (NSNumber *)getWeightUnit {
    return (NSNumber *)[self _getValueForKey:kWeightUnitKey];
}

+ (void)setWeightUnit:(NSNumber *)weightUnit {
    [self _setValue:weightUnit forKey:kWeightUnitKey];
}

+ (NSNumber *)getWeight {
    return (NSNumber *)[self _getValueForKey:kWeightKey];
}

+ (NSNumber *)getWeightInKg {
    NSNumber *weightUnit = [self getWeightUnit];
    NSNumber *weight = nil;
    if (weightUnit) {
        weight = (NSNumber *)[self _getValueForKey:kWeightKey];
        switch (weightUnit.integerValue) {
            case pounds:
                weight = [NSNumber numberWithDouble:weight.integerValue / 2.20462];
                break;
                
            default:
                break;
        }
    }

    return weight;
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

+ (NSNumber *)getGender {
    return (NSNumber *)[self _getValueForKey:kGenderKey];
}

+ (void)setGender:(NSNumber *)gender {
    [self _setValue:gender forKey:kGenderKey];
}

+ (NSNumber *)getMaxHeartRate {
    NSNumber *age = self.getAge;
    if (age) {
        return [NSNumber numberWithInteger:220 - self.getAge.integerValue];
    }
    return [NSNumber numberWithInteger:220];
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
