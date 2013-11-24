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

@interface UserInformationViewController ()
<
UITextFieldDelegate
>

@end

@implementation UserInformationViewController

const static CGFloat padding = 30;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelAgeTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding,
                                                                       padding + self.navigationController.navigationBar.height,
                                                                       self.view.width - padding * 2,
                                                                       padding * 2)];
    [labelAgeTitle applyDefaultStyleWithSize:32.f];
    
    labelAgeTitle.text = NSLocalizedString(@"Age", nil);
    
    [self.view addSubview:labelAgeTitle];
    
    NSNumber *age = [NSUserDefaults getAge];
    
    UITextField *textFieldAge = [[UITextField alloc] initWithFrame:CGRectMake(padding,
                                                                  labelAgeTitle.bottom,
                                                                  self.view.width - padding * 2,
                                                                  padding * 2)];
    [textFieldAge applyDefaultStyleWithSize:28.f];
    textFieldAge.text = age ? [NSString stringWithFormat:@"%@", age] : @"";
    textFieldAge.placeholder = @"Set Age";
    textFieldAge.keyboardType = UIKeyboardTypeNumberPad;
    textFieldAge.delegate = self;
    [self.view addSubview:textFieldAge];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber * myNumber = [f numberFromString:textField.text];
    [NSUserDefaults setAge:myNumber];
}

@end
