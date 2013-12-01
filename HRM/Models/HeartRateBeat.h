//
//  HeartRateBeat.h
//  heartrate
//
//  Created by Jonathan Grana on 11/29/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HeartRateZone;

@interface HeartRateBeat : NSObject

@property (nonatomic)   NSNumber        *bpm;
@property (nonatomic)   NSDate          *time;
@property (nonatomic)   HeartRateZone   *zone;

- (instancetype)initWithBpm:(NSNumber *)bpm andZone:(HeartRateZone *)zone;

@end
