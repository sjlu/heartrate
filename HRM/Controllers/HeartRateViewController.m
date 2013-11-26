#import "HeartRateViewController.h"

#import "UserInformationViewController.h"

#import "UILabel+HeartRate.h"
#import "UIImage+Factory.h"
#import "UIView+Utility.h"
#import "NSUserDefaults+HeartRate.h"
#import "UIColor+HeartRate.h"
#import "NSArray+HeartRate.h"
#import "UIViewController+HeartRate.h"

#import "BluetoothManager.h"//Needed for constants

#import "HeartBeatVerticalChart.h"
#import "HeartRateContainer.h"

#import "HeartRateZone.h"

@interface HeartRateViewController ()

@property (nonatomic)   CATransition                *textAnimation;
@property (nonatomic)   HeartBeatVerticalChart      *heartVerticalChart;
@property (nonatomic)   HeartRateContainer          *heartRateContainer;
@property (nonatomic)   HeartRateZone               *currentZone;
@property (nonatomic)   UILabel                     *heartRateLabel;
@property (nonatomic)   UILabel                     *labelTitle;
@property (nonatomic)   UILabel                     *statusLabel;
@property (nonatomic)   UILabel                     *zoneLabel;

@end

@implementation HeartRateViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kBluetoothNotificationHeartBeat
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage named:@"settings"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(toggleSettings)];
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0, self.navigationController.navigationBar.width, self.navigationController.navigationBar.height)];
    [self.labelTitle applyDefaultStyleWithSize:24.f];
    self.labelTitle.textAlignment = NSTextAlignmentLeft;
    self.navigationItem.titleView = self.labelTitle;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.textAnimation = [CATransition animation];
    self.textAnimation.duration = .5;
    self.textAnimation.type = kCATransitionFade;
    self.textAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    self.heartRateContainer = [[HeartRateContainer alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    
    //TODO: Mave status to it's own view
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 165, self.view.width, 150)];
    [self.statusLabel applyDefaultStyleWithSize:32.f];
    self.statusLabel.text = NSLocalizedString(@"Searching...", nil);
    [self.heartRateContainer addSubview:self.statusLabel];
    
    self.heartRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 165, self.view.width, 150)];
    [self.heartRateLabel applyDefaultStyleWithSize:124.f];
    self.heartRateLabel.text = NSLocalizedString(@"...", nil);
    [self.heartRateContainer addSubview:self.heartRateLabel];
    
    self.zoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.heartRateLabel.bottom + 10, self.view.width, 40)];
    [self.zoneLabel applyDefaultStyleWithSize:32.f];
    [self.heartRateContainer addSubview:self.zoneLabel];
    
    self.heartVerticalChart = [[HeartBeatVerticalChart alloc] initWithFrame:CGRectMake(self.view.width - 32.f, 64.f, 32.f, self.view.height - 64.f)];
    [self.view addSubview:self.heartVerticalChart];
    
    [self.view addSubview:self.heartRateContainer];
    
    //Observe heart beat updates
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateWithBPM:)
                                                 name:kBluetoothNotificationHeartBeat
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    WEAK(self);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSNumber *maxHeartRate = [NSUserDefaults getMaxHeartRate];
        if (maxHeartRate.intValue >= 220) {
            [weak_self toggleSettings];
        }
    });
}

#pragma mark - Selector Methods

- (void)toggleSettings {
}

- (void)updateWithBPM:(NSNotification *)notification {
    NSNumber *beats = notification.object;
    
    [self.heartRateLabel.layer addAnimation:self.textAnimation forKey:@"changeTextTransition"];
    [self.zoneLabel.layer addAnimation:self.textAnimation forKey:@"changeTextTransition"];
    self.heartRateLabel.text = [NSString stringWithFormat:@"%@", beats];
    
    HeartRateZone *currentZone = [[NSArray heartRateZones] currentZoneForBPM:beats];
    
    if ([currentZone.name isEqualToString:self.currentZone.name]) {
        [self sendZoneNotification:currentZone];
    }
    self.currentZone = currentZone;
    
    UIColor *background = [UIColor whiteColor];
    
    if (currentZone) {
        
        self.tintColor = currentZone.zone == resting ? [UIColor heartRateRed] : [UIColor whiteColor];
        self.zoneLabel.text = currentZone.name;
        
        //        NSLog(@"%@", currentZone);
        //TODO: Move color to zone
        switch (currentZone.zone) {
            case max:
                background = [UIColor heartRateRed];
                break;
            case anaerobic:
                background = [UIColor heartRateRed];
                break;
            case aerobic:
                background = [UIColor colorWithRed:(98/255.f) green:(111/255.f) blue:(145/255.f) alpha:1];
                break;
            case weightControl:
                background = [UIColor colorWithRed:(98/255.f) green:(111/255.f) blue:(145/255.f) alpha:1];
                break;
            case moderate:
                background = [UIColor colorWithRed:(127/255.f) green:(164/255.f) blue:(116/255.f) alpha:1];
                break;
            case resting:
                background = [UIColor whiteColor];
                break;
            default:
                break;
        }
    }
    else {
        self.zoneLabel.text = @"";
        self.tintColor = [UIColor heartRateRed];
    }
    
    WEAK(self);
    [UIView animateWithDuration:1.f
                     animations:^{
                         weak_self.view.backgroundColor = background;
                         if (background == [UIColor whiteColor]) {
                             [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
                         }
                         else {
                             [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                         }
                     }];
    
    self.statusLabel.text = @"";
}

- (void)sendZoneNotification:(HeartRateZone *)zone {
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
    {
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil)
            return;
        localNotif.fireDate = [NSDate date];
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        
        // Notification details
        localNotif.alertBody = zone.name;
        // Set the action button
        localNotif.alertAction = @"View";
        
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        
        // Schedule the notification
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
}

@end
