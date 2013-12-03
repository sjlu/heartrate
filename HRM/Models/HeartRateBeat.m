//
//  HeartRateBeat.m
//  heartrate
//
//  Created by Jonathan Grana on 12/2/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "HeartRateBeat.h"

#import "CoreDataManager.h"
#import "HeartRateSession.h"
#import "HeartRateZone.h"

@implementation HeartRateBeat

@dynamic bpm;
@dynamic time;
@dynamic session;
@dynamic rateZone;

- (instancetype)initWithBpm:(NSNumber *)bpm
                    andZone:(HeartRateZone *)zone {
    self = [NSEntityDescription insertNewObjectForEntityForName:@"HeartRateBeat" inManagedObjectContext:[CoreDataManager shared].managedObjectContext];
    
    if (self) {
        self.bpm = bpm;
        self.time = [NSDate new];
        self.rateZone = zone;
    }
    
    return self;
}

@end
