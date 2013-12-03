//
//  HeartRateZone.m
//  heartrate
//
//  Created by Jonathan Grana on 12/3/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "HeartRateZone.h"
#import "HeartRateBeat.h"
#import "HeartRateSession.h"

#import "CoreDataManager.h"
#import "NSUserDefaults+HeartRate.h"

@implementation HeartRateZone

@dynamic minBpm;
@dynamic maxBpm;
@dynamic name;
@dynamic percentage;
@dynamic number;
@dynamic heartZone;
@dynamic age;
@dynamic startTime;
@dynamic endTime;
@dynamic beats;
@dynamic sessions;

-(instancetype)initWithMaxBpm:(NSNumber *)maxBpm
                andPercentage:(CGFloat)percentage {
    self = [NSEntityDescription insertNewObjectForEntityForName:@"HeartRateZone" inManagedObjectContext:[CoreDataManager shared].managedObjectContext];
    if (self) {
        self.minBpm = [NSNumber numberWithInteger:maxBpm.integerValue * percentage];
        self.maxBpm = [NSNumber numberWithInteger:maxBpm.integerValue * (percentage + .1)];
        self.age = [NSUserDefaults getAge];
        self.percentage = [NSNumber numberWithFloat:percentage];
        
        if (percentage >= .89) {
            self.name = NSLocalizedString(@"Max", nil);
            self.number = [NSNumber numberWithInt:6];
            self.heartZone = max;
        }
        else if (percentage >= .79) {
            self.name = NSLocalizedString(@"Anaerobic", nil);
            self.number = [NSNumber numberWithInt:5];
            self.heartZone = anaerobic;
        }
        else if (percentage >= .69) {
            self.name = NSLocalizedString(@"Aerobic", nil);
            self.number = [NSNumber numberWithInt:4];
            self.heartZone = aerobic;
        }
        else if (percentage >= .59) {
            self.name = NSLocalizedString(@"Weight Control", nil);
            self.number = [NSNumber numberWithInt:3];
            self.heartZone = weightControl;
        }
        else if (percentage >= .49) {
            self.name = NSLocalizedString(@"Moderate", nil);
            self.number = [NSNumber numberWithInt:2];
            self.heartZone = moderate;
        }
        else {
            self.name = NSLocalizedString(@"Resting", nil);
            self.number = [NSNumber numberWithInt:1];
            self.heartZone = resting;
        }
    }
    return self;
}

-(NSString *)percentageString {
    return [NSString stringWithFormat:@"%li%%", lroundf(self.percentage.floatValue * 100)];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"Zone %@, MinBPM %@, Percentage: %@", self.name, self.minBpm, self.percentageString];
}

@end
