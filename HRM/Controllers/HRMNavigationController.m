//
//  HRMNavigationController.m
//  heartrate
//
//  Created by Jonathan Grana on 11/30/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "HRMNavigationController.h"

@interface HRMNavigationController ()

@end

@implementation HRMNavigationController

- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (BOOL)wantsFullScreenLayout{
    return YES;
}

@end
