//
//  HeartRateBeat.m
//  heartrate
//
//  Created by Jonathan Grana on 11/29/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "HeartRateBeat.h"

@implementation HeartRateBeat

- (instancetype)initWithBpm:(NSNumber *)bpm
                    andZone:(HeartRateZone *)zone {
    self = [self init];
    
    if (self) {
        self.bpm = bpm;
        self.time = [NSDate new];
    }
    
    return self;
}

@end
