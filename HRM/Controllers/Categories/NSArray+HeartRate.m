#import "NSArray+HeartRate.h"

#import "HeartRateZone.h"
#import "NSUserDefaults+HeartRate.h"

@implementation NSArray (HeartRate)

+(instancetype)heartRateZones {
    NSNumber *maxHeartRate = [NSUserDefaults getMaxHeartRate];
    if (maxHeartRate.integerValue >= 220) {
        return nil;
    }
    else {
        return @[
                 [[HeartRateZone alloc] initWithMaxBpm:maxHeartRate andPercentage:1.f],
                 [[HeartRateZone alloc] initWithMaxBpm:maxHeartRate andPercentage:.9f],
                 [[HeartRateZone alloc] initWithMaxBpm:maxHeartRate andPercentage:.8f],
                 [[HeartRateZone alloc] initWithMaxBpm:maxHeartRate andPercentage:.7f],
                 [[HeartRateZone alloc] initWithMaxBpm:maxHeartRate andPercentage:.6f],
                 [[HeartRateZone alloc] initWithMaxBpm:maxHeartRate andPercentage:.5f],
                 [[HeartRateZone alloc] initWithMaxBpm:maxHeartRate andPercentage:.0f]
                 ];
    }
}

- (HeartRateZone *)currentZoneForBPM:(NSNumber *)bpm {
//    NSLog(@"%@",self);
    for (HeartRateZone *zone in self) {
        NSAssert([zone isKindOfClass:[HeartRateZone class]], @"HeartRateZone Expected");
        if (bpm.integerValue > zone.minBPM.integerValue) {
            return zone;
        }
    }
    
    return [self lastObject];
}

@end
