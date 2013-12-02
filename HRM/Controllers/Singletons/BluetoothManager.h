//
//  Created by Jonathan Grana on 11/24/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBluetoothNotificationHeartBeat             @"Heartbeat"
#define kBluetoothNotificationDeviceConnected       @"DeviceConnect"
#define kBluetoothNotificationDeviceDisconnected    @"DeviceDisconnect"
#define kBluetoothNotificationBattery               @"Battery"

@interface BluetoothManager : NSObject

@property (nonatomic, readonly)     NSMutableArray      *heartRateMonitors;
@property (nonatomic, readonly)     NSString            *deviceName;
@property (nonatomic, readonly)     NSString            *manufactorName;


SHARED_SINGLETON_HEADER(BluetoothManager);

@end
