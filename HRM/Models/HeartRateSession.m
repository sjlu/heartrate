//
//  HeartRateSession.m
//  heartrate
//
//  Created by Jonathan Grana on 12/3/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "HeartRateSession.h"
#import "HeartRateBeat.h"
#import "HeartRateZone.h"

#import "CoreDataManager.h"
#import "NSUserDefaults+HeartRate.h"

@implementation HeartRateSession

@dynamic startTime;
@dynamic endTime;
@dynamic total;
@dynamic beats;
@dynamic rateZones;

- (instancetype)initWithTime:(NSDate *)startTime {
    self = [NSEntityDescription insertNewObjectForEntityForName:@"HeartRateSession" inManagedObjectContext:[CoreDataManager shared].managedObjectContext];
    
    if (self) {
        self.startTime = startTime;
        self.total = [NSNumber numberWithDouble:0.0];
    }
    
    return self;
}

- (void)addBeat:(HeartRateBeat *)beat {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.beats];
    [tempSet addObject:beat];
    self.beats = tempSet;
    self.total = [NSNumber numberWithDouble:(self.total.doubleValue + beat.bpm.doubleValue)];
}

- (NSNumber *)averageBpm {
    return [[NSNumber alloc] initWithDouble:self.total.doubleValue / self.beats.count];
}

/**
 *  For Male,
 *  Calorie Burned = ((-55.0969 + (0.6309 × HR) + (0.1988 × W) + (0.2017 × A)) / 4.184) × 60 × T
 *  For Female,
 *  Calorie Burned = ((-20.4022 + (0.4472 × HR) - (0.1263 × W) + (0.074 × A)) / 4.184) × 60 × T
 *
 *  @return Calories burned
 */
- (NSNumber *)calories {
    NSNumber *gender = [NSUserDefaults getGender];
    NSNumber *calories = nil;
    
    if (gender) {
        NSNumber *age = [NSUserDefaults getAge];
        NSNumber *weight = [NSUserDefaults getWeightInKg];
        if (age && weight) {
            if (gender.integerValue == male) {
                calories = [NSNumber numberWithInteger:((-55.0969 + (0.6309 * self.averageBpm.floatValue) + (0.1988 * weight.floatValue) + (0.2017 * age.floatValue)) / 4.184) * (self.duration.floatValue / 60)];
            }
            else {
                calories = [NSNumber numberWithInteger:((-20.4022 + (0.4472 * self.averageBpm.integerValue) + (0.1263 * weight.integerValue) + (0.074 * age.integerValue)) / 4.184) * (self.duration.floatValue / 60)];
            }
            
        }
    }
    
    return calories;
}

- (NSString *)durationString {
    static const int secondsInHour = 60 * 60;
    
    NSNumber *duration = self.duration;
    
    NSMutableString *time = [[NSMutableString alloc] init];
    
    if (duration.unsignedIntValue > secondsInHour) {
        [time appendString:[NSString stringWithFormat:@"%02d:", duration.unsignedIntegerValue
                            / secondsInHour]];
    }
    [time appendString:[NSString stringWithFormat:@"%02d:", (duration.unsignedIntegerValue / 60) % 60]];
    [time appendString:[NSString stringWithFormat:@"%02d", duration.unsignedIntegerValue % 60]];
    
    return time.copy;
}

- (NSNumber *)duration {
    NSDate *end = self.endTime ? self.endTime : [NSDate new];
    NSTimeInterval interval = [end timeIntervalSinceDate:self.startTime];
    return [NSNumber numberWithDouble:interval];
}

@end
