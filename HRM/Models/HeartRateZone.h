//
//  HeartRateZone.h
//  heartrate
//
//  Created by Jonathan Grana on 11/24/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, heartZones) {
    resting = 1,
    moderate,
    weightControl,
    aerobic,
    anaerobic,
    max
};

@interface HeartRateZone : NSObject

@property (nonatomic)       NSNumber        *minBPM;
@property (nonatomic)       NSNumber        *maxBPM;
@property (nonatomic)       NSNumber        *number;
@property (nonatomic)       NSString        *name;
@property (nonatomic)       NSString        *percentageString;
@property (nonatomic)       CGFloat         percentage;
@property (nonatomic)       heartZones      zone;

-(instancetype)initWithMaxBpm:(NSNumber *)maxBpm
                andPercentage:(CGFloat)percentage;

@end
