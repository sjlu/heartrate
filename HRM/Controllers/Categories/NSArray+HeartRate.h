//
//  Created by Jonathan Grana on 11/24/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HeartRateZone;

@interface NSArray (HeartRate)

+(instancetype)heartRateZones;

- (HeartRateZone *)currentZoneForBPM:(NSNumber *)bpm;

@end
