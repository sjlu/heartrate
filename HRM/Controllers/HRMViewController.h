//
//  HRMViewController.h
//  heartrate
//
//  Created by Jonathan Grana on 11/24/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRMViewController : UIViewController

/**
 This method is called after the keyboard has shown.
 
 This class's view property will have appropriately resized by now.
 @see keyboardDidHide
 */
- (void)keyboardDidShow;
- (void)keyboardDidHide;

/**
 This method can be overridden if you want your subclass to not observer the keyboard and adjust the view's size.
 
 This method returns YES by default.
 This method's return shall not change during the lifecycle of the View Controller.
 */
- (BOOL)shouldObserveKeyboard;

@end
