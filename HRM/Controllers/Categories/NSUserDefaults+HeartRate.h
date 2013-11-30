//
//  NSUserDefaults+HeartRate.h
//  heartrate
//
//  Created by Jonathan Grana on 11/23/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, weightUnitTags) {
    pounds = 0,
    kilograms
};

typedef NS_ENUM(NSInteger, genderTags) {
    male = 0,
    female
};

@interface NSUserDefaults (HeartRate)

+ (NSDate *)getBirthday;
+ (void)setBirthday:(NSDate *)birthday;
+ (NSNumber *)getAge;
+ (NSNumber *)getWeight;
+ (NSNumber *)getWeightInKg;
+ (void)setWeight:(NSNumber *)weight;
+ (NSNumber *)getWeightUnit;
+ (void)setWeightUnit:(NSNumber *)weightUnit;
+ (NSNumber *)getHeight;
+ (void)setHeight:(NSNumber *)height;
+ (NSNumber *)getGender;
+ (void)setGender:(NSNumber *)gender;


+ (NSNumber *)getMaxHeartRate;

@end
