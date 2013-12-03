//
//  HeartRateSession.h
//  heartrate
//
//  Created by Jonathan Grana on 12/3/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HeartRateBeat, HeartRateZone;

@interface HeartRateSession : NSManagedObject

@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSOrderedSet *beats;
@property (nonatomic, retain) NSSet *rateZones;

- (instancetype)initWithTime:(NSDate *)startTime;
- (void)addBeat:(HeartRateBeat *)beat;
- (NSNumber *)averageBpm;
- (NSNumber *)calories;
- (NSString *)durationString;
- (NSNumber *)duration;

@end

@interface HeartRateSession (CoreDataGeneratedAccessors)

- (void)insertObject:(HeartRateBeat *)value inBeatsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBeatsAtIndex:(NSUInteger)idx;
- (void)insertBeats:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBeatsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBeatsAtIndex:(NSUInteger)idx withObject:(HeartRateBeat *)value;
- (void)replaceBeatsAtIndexes:(NSIndexSet *)indexes withBeats:(NSArray *)values;
- (void)addBeatsObject:(HeartRateBeat *)value;
- (void)removeBeatsObject:(HeartRateBeat *)value;
- (void)addBeats:(NSOrderedSet *)values;
- (void)removeBeats:(NSOrderedSet *)values;
- (void)addRateZonesObject:(HeartRateZone *)value;
- (void)removeRateZonesObject:(HeartRateZone *)value;
- (void)addRateZones:(NSSet *)values;
- (void)removeRateZones:(NSSet *)values;

@end
