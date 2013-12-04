//
//  HeartRateZone.h
//  heartrate
//
//  Created by Jonathan Grana on 12/3/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HeartRateBeat, HeartRateSession;

//FIXME: Doesn't persist
typedef NS_ENUM(int16_t, heartZones) {
    resting = 1,
    moderate,
    weightControl,
    aerobic,
    anaerobic,
    max
};

@interface HeartRateZone : NSManagedObject

@property (nonatomic, retain) NSNumber * minBpm;
@property (nonatomic, retain) NSNumber * maxBpm;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * percentage;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSSet *beats;
@property (nonatomic, retain) NSSet *sessions;
@property (nonatomic) heartZones heartZone;

-(instancetype)initWithMaxBpm:(NSNumber *)maxBpm
                andPercentage:(CGFloat)percentage;

-(NSString *)percentageString;

@end

@interface HeartRateZone (CoreDataGeneratedAccessors)

- (void)addBeatsObject:(HeartRateBeat *)value;
- (void)removeBeatsObject:(HeartRateBeat *)value;
- (void)addBeats:(NSSet *)values;
- (void)removeBeats:(NSSet *)values;

- (void)addSessionsObject:(HeartRateSession *)value;
- (void)removeSessionsObject:(HeartRateSession *)value;
- (void)addSessions:(NSSet *)values;
- (void)removeSessions:(NSSet *)values;

@end
