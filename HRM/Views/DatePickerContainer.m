//
//  DatePickerContainer.m
//  heartrate
//
//  Created by Jonathan Grana on 11/29/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "DatePickerContainer.h"

#import "UIView+Utility.h"
#import "UIColor+HeartRate.h"

@interface DatePickerContainer()

@end

@implementation DatePickerContainer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.width, 44.f)];
        [bar setItems:@[
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDate)],[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil],
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveDate)]]
             animated:YES];
        bar.tintColor = [UIColor heartRateRed];
        bar.barTintColor = [UIColor whiteColor];
        [self addSubview:bar];
        self.picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44.f, self.width, self.height - 44.f)];
        self.picker.backgroundColor = [UIColor whiteColor];
        self.picker.tintColor = [UIColor whiteColor];
        self.picker.datePickerMode = UIDatePickerModeDate;
        [self addSubview:self.picker];
    }
    return self;
}

- (void)cancelDate {
    if (self.doneBlock) {
        self.doneBlock(self.picker, YES);
    }
}

- (void)saveDate {
    if (self.doneBlock) {
        self.doneBlock(self.picker, NO);
    }
}

@end
