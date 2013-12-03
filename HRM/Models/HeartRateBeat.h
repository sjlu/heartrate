//
//  HeartRateBeat.h
//  heartrate
//
//  Created by Jonathan Grana on 12/2/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HeartRateSession, HeartRateZone;

@interface HeartRateBeat : NSManagedObject

@property (nonatomic, retain) NSNumber * bpm;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) HeartRateSession *session;
@property (nonatomic, retain) HeartRateZone *rateZone;

- (instancetype)initWithBpm:(NSNumber *)bpm
                    andZone:(HeartRateZone *)zone;

@end
