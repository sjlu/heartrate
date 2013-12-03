//
//  Created by Jonathan Grana on 11/24/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HeartRateZone;

@interface NSArray (HeartRate)

/**
 *  Checks db for default zones for current age, otherwise populates db and returns new zones
 *
 *  @return NSArray of heart rate zones
 */
+(instancetype)heartRateZones;

- (HeartRateZone *)currentZoneForBPM:(NSNumber *)bpm;

@end
