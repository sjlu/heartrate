//
//  Created by Jonathan Grana on 11/24/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBluetoothNotificationHeartBeat     @"Heartbeat"
#define kBluetoothNotificationFoundDevice   @"FoundDevice"

@interface BluetoothManager : NSObject

@property (nonatomic, readonly)   NSMutableArray      *heartRateMonitors;

SHARED_SINGLETON_HEADER(BluetoothManager);

@end
