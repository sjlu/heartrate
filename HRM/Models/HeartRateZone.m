//
//  HeartRateZone.m
//  heartrate
//
//  Created by Jonathan Grana on 11/24/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "HeartRateZone.h"

@implementation HeartRateZone

-(instancetype)initWithMaxBpm:(NSNumber *)maxBpm
                andPercentage:(CGFloat)percentage {
    self = [self init];
    if (self) {
        self.minBPM = [NSNumber numberWithInteger:maxBpm.integerValue * percentage];
        self.maxBPM = [NSNumber numberWithInteger:maxBpm.integerValue * (percentage + .1)];
        
        self.percentage = percentage;
        
        if (percentage >= .89) {
            self.name = NSLocalizedString(@"Max", nil);
            self.zone = max;
        }
        else if (percentage >= .79) {
            self.name = NSLocalizedString(@"Anaerobic", nil);
            self.zone = anaerobic;
        }
        else if (percentage >= .69) {
            self.name = NSLocalizedString(@"Aerobic", nil);
            self.zone = aerobic;
        }
        else if (percentage >= .59) {
            self.name = NSLocalizedString(@"Weight Control", nil);
            self.zone = weightControl;
        }
        else if (percentage >= .49) {
            self.name = NSLocalizedString(@"Moderate", nil);
            self.zone = moderate;
        }
        else {
            self.name = NSLocalizedString(@"Resting", nil);
            self.zone = resting;
        }
        
        self.percentageString = [NSString stringWithFormat:@"%li%%", lroundf(percentage * 100)];
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"Zone %@, MinBPM %@, Percentage: %@", self.name, self.minBPM, self.percentageString];
}

@end