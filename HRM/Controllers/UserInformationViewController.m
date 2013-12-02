//
//  UserInformationViewController.m
//  heartrate
//
//  Created by Jonathan Grana on 11/21/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "UserInformationViewController.h"

#import "DatePickerContainer.h"
#import "IIViewDeckController.h"
#import "NSUserDefaults+HeartRate.h"
#import "UIColor+HeartRate.h"
#import "UILabel+HeartRate.h"
#import "UISegmentedControl+HeartRate.h"
#import "UITextField+HeartRate.h"
#import "UIView+Utility.h"

@interface UserInformationViewController ()
<
UITextFieldDelegate
>

@property (nonatomic) UIScrollView          *scrollView;
@property (nonatomic) UISegmentedControl    *segmentGender;
@property (nonatomic) UISegmentedControl    *segmentWeightUnit;
@property (nonatomic) UISegmentedControl    *segmentHeightUnit;
@property (nonatomic) UITextField           *textFieldWeight;

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
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.view.backgroundColor = [UIColor heartRateRed];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.title = NSLocalizedString(@"Profile Settings", nil);
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.clipsToBounds = YES;
    //    self.scrollView.alwaysBounceVertical = YES;
    
    UILabel *labelAgeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       self.view.width,
                                                                       padding * 1.5)];
    [labelAgeTitle applyDefaultStyleWithSize:22.f];
    labelAgeTitle.textColor = [UIColor whiteColor];
    
    labelAgeTitle.text = NSLocalizedString(@"Birthday", nil);
    
    [self.scrollView addSubview:labelAgeTitle];
    
    NSDate *birthday = [NSUserDefaults getBirthday];
    
    UITextField *textFieldAge = [[UITextField alloc] initWithFrame:CGRectMake(padding,
                                                                              labelAgeTitle.top + padding * 1.5,
                                                                              self.view.width - padding * 2,
                                                                              padding * 1.5)];
    [textFieldAge applyDefaultStyleWithSize:22.f];
    textFieldAge.tag = ageTag;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M/d/yyyy";
    textFieldAge.text = birthday ? [formatter stringFromDate:birthday] : @"";
    textFieldAge.placeholder = NSLocalizedString(@"Set Birthday", nil);
    
    DatePickerContainer *datePicker = [[DatePickerContainer alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 216.f)];
    if (birthday) {
        datePicker.picker.date = birthday;
    }
    datePicker.doneBlock = ^(UIDatePicker* picker, BOOL cancelled) {
        [textFieldAge resignFirstResponder];
        if (!cancelled) {
            [NSUserDefaults setBirthday:picker.date];
            textFieldAge.text = [formatter stringFromDate:picker.date];
        }
    };
    
    textFieldAge.inputView = datePicker;
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
    
    NSNumber *weight = [NSUserDefaults getWeight];
    
    self.self.textFieldWeight = [[UITextField alloc] initWithFrame:CGRectMake(padding,
                                                                                 labelWeightTitle.top + padding * 1.5,
                                                                                 (self.view.width - padding * 2.5) / 2,
                                                                                 padding * 1.5)];
    [self.textFieldWeight applyDefaultStyleWithSize:22.f];
    self.textFieldWeight.tag = weightTag;
    self.textFieldWeight.text = weight ? [NSString stringWithFormat:@"%@", weight] : @"";
    self.textFieldWeight.placeholder = NSLocalizedString(@"Set Weight", nil);
    self.textFieldWeight.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldWeight.delegate = self;
    [self.scrollView addSubview:self.textFieldWeight];
    
    self.segmentWeightUnit = [UISegmentedControl defaultSegmentedControlWithItems:@[@"lbs", @"kgs"]];
    self.segmentWeightUnit.frame = CGRectMake(self.textFieldWeight.right + padding / 2,
                                          self.textFieldWeight.top,
                                          (self.view.width - padding * 2.5) / 2,
                                          self.textFieldWeight.height);
    [self.segmentWeightUnit addTarget:self
                           action:@selector(weightChanged)
                 forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.segmentWeightUnit];
    
    NSNumber *weightUnit = [NSUserDefaults getWeightUnit];
    
    if (weightUnit) {
        self.segmentWeightUnit.selectedSegmentIndex = weightUnit.integerValue;
    }
    else {
        //Default to pounds
        self.segmentWeightUnit.selectedSegmentIndex = 0;
        [self weightChanged];
    }

    //Removing height for now since it is not used
    /*
    UILabel *labelHeightTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                          self.textFieldWeight.bottom,
                                                                          self.view.width,
                                                                          padding * 1.5)];
    [labelHeightTitle applyDefaultStyleWithSize:22.f];
    labelHeightTitle.textColor = [UIColor whiteColor];
    
    labelHeightTitle.text = NSLocalizedString(@"Height", nil);
    
    [self.scrollView addSubview:labelHeightTitle];
    
    NSNumber *height = [NSUserDefaults getHeight];
    
    UITextField *textFieldHeight = [[UITextField alloc] initWithFrame:CGRectMake(padding,
                                                                                 labelHeightTitle.top + padding * 1.5,
                                                                                 (self.view.width - padding * 2.5) / 2,
                                                                                 padding * 1.5)];
    [textFieldHeight applyDefaultStyleWithSize:22.f];
    textFieldHeight.tag = heightTag;
    textFieldHeight.text = height ? [NSString stringWithFormat:@"%@", height] : @"";
    textFieldHeight.placeholder = NSLocalizedString(@"Set Height", nil);
    textFieldHeight.keyboardType = UIKeyboardTypeNumberPad;
    textFieldHeight.delegate = self;
    [self.scrollView addSubview:textFieldHeight];
    
    
    self.segmentHeightUnit = [UISegmentedControl defaultSegmentedControlWithItems:@[@"ft/in", @"m/cm"]];
    self.segmentHeightUnit.frame = CGRectMake(textFieldHeight.right + padding / 2,
                                              textFieldHeight.top,
                                              (self.view.width - padding * 2.5) / 2,
                                              textFieldHeight.height);
    self.segmentHeightUnit.selectedSegmentIndex = 0;
    [self.scrollView addSubview:self.segmentHeightUnit];
    */
     
    UILabel *labelGenderTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                          self.textFieldWeight.bottom,
                                                                          self.view.width,
                                                                          padding * 1.5)];
    [labelGenderTitle applyDefaultStyleWithSize:22.f];
    labelGenderTitle.textColor = [UIColor whiteColor];
    
    labelGenderTitle.text = NSLocalizedString(@"Gender", nil);
    
    [self.scrollView addSubview:labelGenderTitle];
    
    NSNumber *gender = [NSUserDefaults getGender];
    
    self.segmentGender = [UISegmentedControl defaultSegmentedControlWithItems:@[@"Male", @"Female"]];
    self.segmentGender.frame = CGRectMake(padding,
                                     labelGenderTitle.top + padding * 1.5,
                                     self.view.width - padding * 2,
                                     padding * 1.5);
    self.segmentGender.tag = genderTag;
    [self.scrollView addSubview:self.segmentGender];
    
    if (gender) {
        self.segmentGender.selectedSegmentIndex = gender.integerValue;
    }
    else {
        self.segmentGender.selectedSegmentIndex = 0;
        [self genderChanged];
    }
    
    [self.segmentGender addTarget:self
                      action:@selector(genderChanged)
            forControlEvents:UIControlEventValueChanged];
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.segmentGender.bottom + padding);
    
    [self.view addSubview:self.scrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.view
                                                                          action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tap];
    //Separate Controllers
    //TODO:Allow user to set resting heart rate?
}

- (void)genderChanged {
    [NSUserDefaults setGender:[NSNumber numberWithInteger:self.segmentGender.selectedSegmentIndex]];
}

- (void)weightChanged {
    [NSUserDefaults setWeightUnit:[NSNumber numberWithInteger:self.segmentWeightUnit.selectedSegmentIndex]];
    [self textFieldDidEndEditing:self.self.textFieldWeight];
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
    NSNumber *myNumber = [f numberFromString:textField.text];
    
    switch (textField.tag) {
        case weightTag:
            [NSUserDefaults setWeight:myNumber];
            break;
        case heightTag:
            [NSUserDefaults setHeight:myNumber];
            break;
        default:
            break;
    }
    
    [textField resignFirstResponder];
}

@end
