//
//  UserInformationViewController.m
//  heartrate
//
//  Created by Jonathan Grana on 11/21/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "UserInformationViewController.h"

#import "UIView+Utility.h"
#import "UILabel+HeartRate.h"
#import "UITextField+HeartRate.h"
#import "NSUserDefaults+HeartRate.h"
#import "UIColor+HeartRate.h"

@interface UserInformationViewController ()
<
UITextFieldDelegate
>

@end

@implementation UserInformationViewController

const static CGFloat padding = 30;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [self init];
    
    if (self) {
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor clearColor];
        self.title = NSLocalizedString(@"Target Heart Zone", nil);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 5.f, 1.f)];
    divider.backgroundColor = [UIColor heartRateRed];
    [self.view addSubview:divider];
    
    UILabel *labelAgeTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding * 2,
                                                                       padding * 1.5,
                                                                       self.view.width / 3,
                                                                       padding * 1.5)];
    [labelAgeTitle applyDefaultStyleWithSize:32.f];
    
    labelAgeTitle.text = NSLocalizedString(@"Age", nil);
    
    [self.view addSubview:labelAgeTitle];
    
    NSNumber *age = [NSUserDefaults getAge];
    
    UITextField *textFieldAge = [[UITextField alloc] initWithFrame:CGRectMake(labelAgeTitle.right,
                                                                  labelAgeTitle.top - 32,
                                                                  self.view.width / 3,
                                                                  padding * 1.5)];
    [textFieldAge applyDefaultStyleWithSize:32.f];
    textFieldAge.text = age ? [NSString stringWithFormat:@"%@", age] : @"";
    textFieldAge.placeholder = @"Set Age";
    textFieldAge.keyboardType = UIKeyboardTypeNumberPad;
    textFieldAge.delegate = self;
    [self.view addSubview:textFieldAge];
    
    //Separate Controllers
    //TODO:Add list of broadcasting devices and show current device
    //TODO:Allow user to set resting heart rate
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber * myNumber = [f numberFromString:textField.text];
    [NSUserDefaults setAge:myNumber];
}

@end
