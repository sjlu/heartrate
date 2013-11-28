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
#import "IIViewDeckController.h"
#import "UISegmentedControl+HeartRate.h"

@interface UserInformationViewController ()
<
UITextFieldDelegate
>

@property (nonatomic) UIScrollView      *scrollView;

@end

@implementation UserInformationViewController

typedef NS_ENUM(NSInteger, userFieldTags) {
    ageTag = 1,
    weightTag,
    heightTag,
    genderTag,
};

const static CGFloat padding = 30;

- (BOOL)shouldObserveKeyboard {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor heartRateRed];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.title = NSLocalizedString(@"Profile Settings", nil);
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor heartRateRed];
    
//    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 5.f, 1.f)];
//    divider.backgroundColor = [UIColor heartRateRed];
//    [self.view addSubview:divider];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.clipsToBounds = YES;
//    self.scrollView.alwaysBounceVertical = YES;
    
    UILabel *labelAgeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       self.view.width,
                                                                       padding * 1.5)];
    [labelAgeTitle applyDefaultStyleWithSize:22.f];
    labelAgeTitle.textColor = [UIColor whiteColor];
    
    labelAgeTitle.text = NSLocalizedString(@"Age", nil);
    
    [self.scrollView addSubview:labelAgeTitle];
    
    NSNumber *age = [NSUserDefaults getAge];
    
    UITextField *textFieldAge = [[UITextField alloc] initWithFrame:CGRectMake(padding,
                                                                  labelAgeTitle.top + padding * 1.5,
                                                                  self.view.width - padding * 2,
                                                                  padding * 1.5)];
    [textFieldAge applyDefaultStyleWithSize:22.f];
    textFieldAge.tag = ageTag;
    textFieldAge.text = age ? [NSString stringWithFormat:@"%@", age] : @"";
    textFieldAge.placeholder = NSLocalizedString(@"Set Age", nil);
    textFieldAge.keyboardType = UIKeyboardTypeNumberPad;
    textFieldAge.delegate = self;
    [self.scrollView addSubview:textFieldAge];
    
    UILabel *labelWeightTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                       textFieldAge.bottom,
                                                                       self.view.width,
                                                                       padding * 1.5)];
    [labelWeightTitle applyDefaultStyleWithSize:22.f];
    labelWeightTitle.textColor = [UIColor whiteColor];
    
    labelWeightTitle.text = NSLocalizedString(@"Weight", nil);
    
    [self.scrollView addSubview:labelWeightTitle];
    
    NSNumber *weight = [NSUserDefaults getAge];
    
    UITextField *textFieldWeight = [[UITextField alloc] initWithFrame:CGRectMake(padding,
                                                                              labelWeightTitle.top + padding * 1.5,
                                                                              self.view.width - padding * 2,
                                                                              padding * 1.5)];
    [textFieldWeight applyDefaultStyleWithSize:22.f];
    textFieldWeight.tag = weightTag;
    textFieldWeight.text = weight ? [NSString stringWithFormat:@"%@", weight] : @"";
    textFieldWeight.placeholder = NSLocalizedString(@"Set Weight", nil);
    textFieldWeight.keyboardType = UIKeyboardTypeNumberPad;
    textFieldWeight.delegate = self;
    [self.scrollView addSubview:textFieldWeight];
    
    UILabel *labelHeightTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                          textFieldWeight.bottom,
                                                                          self.view.width,
                                                                          padding * 1.5)];
    [labelHeightTitle applyDefaultStyleWithSize:22.f];
    labelHeightTitle.textColor = [UIColor whiteColor];
    
    labelHeightTitle.text = NSLocalizedString(@"Height", nil);
    
    [self.scrollView addSubview:labelHeightTitle];
    
    NSNumber *height = [NSUserDefaults getAge];
    
    UITextField *textFieldHeight = [[UITextField alloc] initWithFrame:CGRectMake(padding,
                                                                                 labelHeightTitle.top + padding * 1.5,
                                                                                 self.view.width - padding * 2,
                                                                                 padding * 1.5)];
    [textFieldHeight applyDefaultStyleWithSize:22.f];
    textFieldHeight.tag = heightTag;
    textFieldHeight.text = height ? [NSString stringWithFormat:@"%@", height] : @"";
    textFieldHeight.placeholder = NSLocalizedString(@"Set Height", nil);
    textFieldHeight.keyboardType = UIKeyboardTypeNumberPad;
    textFieldHeight.delegate = self;
    [self.scrollView addSubview:textFieldHeight];
    
    UILabel *labelGenderTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                          textFieldHeight.bottom,
                                                                          self.view.width,
                                                                          padding * 1.5)];
    [labelGenderTitle applyDefaultStyleWithSize:22.f];
    labelGenderTitle.textColor = [UIColor whiteColor];
    
    labelGenderTitle.text = NSLocalizedString(@"Gender", nil);
    
    [self.scrollView addSubview:labelGenderTitle];
    
    NSNumber *gender = [NSUserDefaults getAge];
    
    UISegmentedControl *textFieldGender = [UISegmentedControl defaultSegmentedControlWithItems:@[@"Male", @"Female"]];
    textFieldGender.frame = CGRectMake(padding,
                                       labelGenderTitle.top + padding * 1.5,
                                       self.view.width - padding * 2,
                                       padding * 1.5);
    textFieldGender.tag = genderTag;
    [self.scrollView addSubview:textFieldGender];
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, textFieldGender.bottom + padding);
    
    [self.view addSubview:self.scrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.view
                                                                          action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tap];
    //Separate Controllers
    //TODO:Add list of broadcasting devices and show current device
    //TODO:Allow user to set resting heart rate
}

- (void)keyboardDidShow {
    self.scrollView.frame = self.view.frame;
}
//
- (void)keyboardDidHide {
    self.scrollView.frame = self.view.frame;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return !self.viewDeckController.isAnySideOpen;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber * myNumber = [f numberFromString:textField.text];
    [NSUserDefaults setAge:myNumber];
    [textField resignFirstResponder];
}

@end
