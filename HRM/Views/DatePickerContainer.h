//
//  DatePickerContainer.h
//  heartrate
//
//  Created by Jonathan Grana on 11/29/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PickerBlock)(UIDatePicker *picker, BOOL cancelled);

@interface DatePickerContainer : UIView

@property (nonatomic, copy)     PickerBlock         doneBlock;
@property (nonatomic)           UIDatePicker        *picker;

@end
