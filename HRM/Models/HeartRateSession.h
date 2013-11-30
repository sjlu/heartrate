//
//  HeartRateSession.h
//  heartrate
//
//  Created by Jonathan Grana on 11/26/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HeartRateBeat;

@interface HeartRateSession : NSObject

@property (nonatomic)       NSDate              *startTime;
@property (nonatomic)       NSDate              *endTime;
@property (nonatomic)       NSMutableArray      *beats;

- (instancetype)initWithTime:(NSDate *)startTime;
- (void)addBeat:(HeartRateBeat *)beat;

- (NSString *)durationString;

/**
 *  Returns number of seconds
 *
 *  @return NSNumber of seconds
 */
- (NSNumber *)duration;

- (NSNumber *)averageBpm;

- (NSNumber *)calories;

@end
