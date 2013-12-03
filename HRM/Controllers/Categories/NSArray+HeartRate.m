#import "NSArray+HeartRate.h"

#import "HeartRateZone.h"
#import "NSUserDefaults+HeartRate.h"
#import "CoreDataManager.h"

@implementation NSArray (HeartRate)

+(instancetype)heartRateZones {
    NSNumber *age = [NSUserDefaults getAge];
    if (age) {
        //Query for default zones for this age
        NSEntityDescription *entityDescription = [NSEntityDescription
                                                  entityForName:@"HeartRateZone" inManagedObjectContext:[CoreDataManager shared].managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"(age == %@)", age];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            initWithKey:@"minBpm" ascending:YES];
        [request setSortDescriptors:@[sortDescriptor]];
        
        NSError *error;
        NSArray *array = [[CoreDataManager shared].managedObjectContext executeFetchRequest:request
                                                                                      error:&error];
        if (array && array.count > 0) {
            return array;
        }
        else {
            NSNumber *maxHeartRate = [NSUserDefaults getMaxHeartRate];
            return @[
                     [[HeartRateZone alloc] initWithMaxBpm:maxHeartRate andPercentage:.9f],
                     [[HeartRateZone alloc] initWithMaxBpm:maxHeartRate andPercentage:.8f],
                     [[HeartRateZone alloc] initWithMaxBpm:maxHeartRate andPercentage:.7f],
                     [[HeartRateZone alloc] initWithMaxBpm:maxHeartRate andPercentage:.6f],
                     [[HeartRateZone alloc] initWithMaxBpm:maxHeartRate andPercentage:.5f],
                     [[HeartRateZone alloc] initWithMaxBpm:maxHeartRate andPercentage:.0f]
                     ];
            
        }
    }
    else {
        return nil;
    }
}

- (HeartRateZone *)currentZoneForBPM:(NSNumber *)bpm {
    //    NSLog(@"%@",self);
    for (HeartRateZone *zone in self) {
        NSAssert([zone isKindOfClass:[HeartRateZone class]], @"HeartRateZone Expected");
        if (bpm.integerValue > zone.minBpm.integerValue) {
            return zone;
        }
    }
    
    return [self lastObject];
}

@end
