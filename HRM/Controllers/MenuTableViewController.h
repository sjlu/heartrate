//
//  MenuTableViewController.h
//  heartrate
//
//  Created by Jonathan Grana on 11/25/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HRMViewController.h"

@interface MenuTableViewController : HRMViewController

/**
 *  We retain the heart rate to keep the timers going
 */
@property (nonatomic, readonly)     UINavigationController         *navHeartRate;

@end
