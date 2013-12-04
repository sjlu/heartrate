#import "HeartRateViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "UserInformationViewController.h"

#import "BluetoothManager.h"//Needed for constants
#import "HeartBeatVerticalChart.h"
#import "HeartRateBeat.h"
#import "HeartRateContainer.h"
#import "HeartRateGraph.h"
#import "HeartRateSession.h"
#import "HeartRateZone.h"
#import "IIViewDeckController.h"
#import "NSArray+HeartRate.h"
#import "NSUserDefaults+HeartRate.h"
#import "UIButton+HeartRate.h"
#import "UIColor+HeartRate.h"
#import "UIImage+Factory.h"
#import "UILabel+HeartRate.h"
#import "UIView+Utility.h"
#import "UIViewController+HeartRate.h"
#import "UIFont+HeartRate.h"
#import "CoreDataManager.h"

@interface HeartRateViewController ()

@property (nonatomic)   CATransition                *textAnimation;
@property (nonatomic)   HeartRateContainer          *heartRateContainer;
@property (nonatomic)   HeartRateZone               *currentZone;
@property (nonatomic)   NSTimer                     *timer;
@property (nonatomic)   UIButton                    *startButton;
@property (nonatomic)   UIButton                    *resetButton;
@property (nonatomic)   UILabel                     *averageLabel;
@property (nonatomic)   UILabel                     *caloriesLabel;
@property (nonatomic)   UILabel                     *heartRateLabel;
@property (nonatomic)   UILabel                     *timeLabel;
@property (nonatomic)   HeartRateSession            *session;

@property (nonatomic)   HeartRateGraph              *heartGraph;

//TODO: Update Vertical Chart, zones and status
@property (nonatomic)   HeartBeatVerticalChart      *heartVerticalChart;
@property (nonatomic)   UILabel                     *zoneLabel;

@property (nonatomic)	AVAudioPlayer               *avSound;

@end

@implementation HeartRateViewController

static const CGFloat padding = 30.f;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kBluetoothNotificationHeartBeat
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor heartRateRed];
    
    self.textAnimation = [CATransition animation];
    self.textAnimation.duration = .5;
    self.textAnimation.type = kCATransitionFade;
    self.textAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    self.startButton = [UIButton defaultButtonWithFrame:CGRectMake(0, self.view.height - padding * 1.5, self.view.width / 2-1, padding * 1.5 + 1) andTitle:NSLocalizedString(@"Start", nil)];
    [self.startButton addTarget:self
                         action:@selector(toggleTime)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startButton];
    
    self.resetButton = [UIButton defaultButtonWithFrame:CGRectMake(self.view.width / 2 + 1, self.view.height - padding * 1.5, self.view.width / 2 - 1, padding * 1.5 + 1) andTitle:NSLocalizedString(@"Reset", nil)];
    [self.resetButton addTarget:self
                         action:@selector(resetTime)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.resetButton];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    [self.timeLabel applyDefaultStyleWithSize:40.f];
    self.timeLabel.clipsToBounds = NO;
    self.timeLabel.text = @"00:00";
    [self.view addSubview:self.timeLabel];
    
    self.averageLabel = [[UILabel alloc] initWithFrame:CGRectMake(-1, self.timeLabel.bottom, self.view.width / 2 + 2, 54.f)];
    [self.averageLabel applyDefaultStyleWithSize:30.f];
    self.averageLabel.text = @"0";
    //    self.averageLabel.layer.borderWidth = 1.f;
    //    self.averageLabel.layer.borderColor = [UIColor heartRateRed].CGColor;
    [self.view addSubview:self.averageLabel];
    
    UILabel *averageTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.averageLabel.height - self.averageLabel.height / 2.5, self.averageLabel.width, self.averageLabel.height / 2)];
    [averageTitleLable applyDefaultStyleWithSize:12.f];
    averageTitleLable.text = NSLocalizedString(@"Average BPM", nil);
    [self.averageLabel addSubview:averageTitleLable];
    
    self.caloriesLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width / 2-1, self.timeLabel.bottom, self.view.width / 2 + 2, 54.f)];
    [self.caloriesLabel applyDefaultStyleWithSize:30.f];
    self.caloriesLabel.text = @"0";
    //    self.averageLabel.layer.borderWidth = 1.f;
    //    self.averageLabel.layer.borderColor = [UIColor heartRateRed].CGColor;
    [self.view addSubview:self.caloriesLabel];
    
    UILabel *calorieTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.caloriesLabel.height - self.caloriesLabel.height / 2.5, self.caloriesLabel.width, self.caloriesLabel.height / 2)];
    [calorieTitleLable applyDefaultStyleWithSize:12.f];
    calorieTitleLable.text = NSLocalizedString(@"Calories Burned", nil);
    [self.caloriesLabel addSubview:calorieTitleLable];
    
    self.heartRateContainer = [[HeartRateContainer alloc] initWithFrame:CGRectMake(0, self.averageLabel.bottom, self.view.width, 130.f)];
    
    self.heartRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
    [self.heartRateLabel applyDefaultStyleWithSize:124.f];
    self.heartRateLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    self.heartRateLabel.text = NSLocalizedString(@"...", nil);
    [self.heartRateContainer addSubview:self.heartRateLabel];
    
    self.zoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.heartRateLabel.bottom + 10, self.view.width, 40)];
    [self.zoneLabel applyDefaultStyleWithSize:32.f];
    self.zoneLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.heartRateContainer addSubview:self.zoneLabel];
    
    [self.view addSubview:self.heartRateContainer];
    
    //    self.heartVerticalChart = [[HeartBeatVerticalChart alloc] initWithFrame:CGRectMake(self.view.width - 32.f, 64.f, 32.f, self.view.height - 64.f - padding * 1.5)];
    //    [self.view addSubview:self.heartVerticalChart];
    
    self.heartGraph = [[HeartRateGraph alloc] initWithFrame:CGRectMake(0, self.view.height / 2, self.view.width, self.view.height / 2 - padding * 1.5)];
    [self.view addSubview:self.heartGraph];
    
    //Observe heart beat updates
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateWithBPM:)
                                                 name:kBluetoothNotificationHeartBeat
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    WEAK(self);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSNumber *maxHeartRate = [NSUserDefaults getMaxHeartRate];
        if (maxHeartRate.intValue >= 220) {
            //TODO:Ask user to fill out profile
            
            //[weak_self toggleSettings];
        }
    });
}

- (void)viewWillLayoutSubviews {
    
    self.startButton.frame = CGRectMake(0, self.view.height - padding * 1.5, self.view.width / 2 - .5, padding * 1.5);
    self.resetButton.frame = CGRectMake(self.view.width / 2 + .5, self.view.height - padding * 1.5, self.view.width / 2 - .5, padding * 1.5);
    
    
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        //        self.averageLabel.top = 10;
        self.averageLabel.top = 10;
        self.averageLabel.width = self.view.width / 5;
        self.timeLabel.font = [UIFont defaultFontWithSize:30.f];
        self.heartRateLabel.font = [UIFont defaultFontWithSize:94.f];
        //    self.averageTitleLable.frame = CGRectMake(0, self.averageLabel.bottom - self.averageLabel.height / 2.5, self.averageLabel.width, self.averageLabel.height / 2);
        self.timeLabel.left = self.averageLabel.right;
        self.timeLabel.width = self.view.width / 5;
        self.caloriesLabel.left = self.timeLabel.right;
        self.caloriesLabel.top = 10;
        self.caloriesLabel.width = self.view.width / 5;
        
        self.heartRateContainer.frame = CGRectMake(self.caloriesLabel.right, - 30, self.view.width - self.caloriesLabel.right, self.view.height - padding * 1.5);
        self.navigationController.navigationBar.hidden = YES;
        self.heartGraph.height = self.view.height - self.averageLabel.height - self.startButton.height - 10;
        self.heartGraph.top = self.averageLabel.bottom;
        self.viewDeckController.enabled = NO;
        self.zoneLabel.hidden = YES;
    }
    else {
        self.navigationController.navigationBar.hidden = NO;
        self.viewDeckController.enabled = YES;
        self.zoneLabel.hidden = NO;
        self.timeLabel.font = [UIFont defaultFontWithSize:40.f];
        self.heartRateLabel.font = [UIFont defaultFontWithSize:124.f];
        self.averageLabel.left = 0;
        self.averageLabel.top = self.caloriesLabel.top = self.timeLabel.bottom;
        self.averageLabel.width = self.view.width / 2;
        self.caloriesLabel.left = self.view.width / 2;
        self.caloriesLabel.width = self.view.width / 2;
        self.timeLabel.frame = CGRectMake(0, 20, self.view.width, 44);
        self.heartRateContainer.frame = CGRectMake(0, self.averageLabel.bottom, self.view.width, self.view.height - self.averageLabel.bottom - (self.view.height / 2 - padding * 1.5));
        self.heartGraph.frame = CGRectMake(0, self.view.height / 2, self.view.width, self.view.height / 2 - padding * 1.5);
    }
    [self.averageLabel centerSubviewsHorizontally];
    [self.caloriesLabel centerSubviewsHorizontally];
}



- (BOOL)shouldAutorotate {
    //    return NO;
    return !self.viewDeckController.isAnySideOpen;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Selector Methods

- (void)clearTimer {
    [self.startButton setTitle:NSLocalizedString(@"Start", nil)
                      forState:UIControlStateNormal];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = 0;
    }
    
    self.session = nil;
}

- (void)toggleTime {
    if (self.timer) {
        [self clearTimer];
        self.session.endTime = [NSDate date];
        
        [[CoreDataManager shared] saveContext];
    }
    else {
        [self.startButton setTitle:NSLocalizedString(@"Stop", nil)
                          forState:UIControlStateNormal];
        self.session = [[HeartRateSession alloc] initWithTime:[NSDate new]];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(updateTime)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)resetTime {
    if (self.timer) {
        [self clearTimer];
        self.session = nil;
    }
    self.timeLabel.text = @"00:00";
    self.averageLabel.text = @"0";
    self.caloriesLabel.text = @"0";
}

- (void)updateTime {
    self.timeLabel.text = self.session.durationString;
    
    if (self.session.calories) {
        self.caloriesLabel.text = [NSString stringWithFormat:@"%@", self.session.calories];
    }
    
    self.averageLabel.text = [NSString stringWithFormat:@"%.1f", self.session.averageBpm.floatValue];
}

- (void)updateWithBPM:(NSNotification *)notification {
    NSNumber *beats = notification.object;
    
    [self.heartRateLabel.layer addAnimation:self.textAnimation forKey:@"changeTextTransition"];
    self.heartRateLabel.text = [NSString stringWithFormat:@"%@", beats];
    
    HeartRateZone *currentZone = nil;
    UIColor *background = [UIColor whiteColor];
    
    if (self.session) {
        [self.zoneLabel.layer addAnimation:self.textAnimation forKey:@"changeTextTransition"];
        
        //TODO: Move default zones generator to HeartRateZones and return set
        if (self.session.rateZones.count < 1) {
            self.session.rateZones = [NSSet setWithArray:[NSArray heartRateZones]];
        }
        NSArray *zones = self.session.rateZones.allObjects;
        
        currentZone = [zones currentZoneForBPM:beats];
        HeartRateBeat *beat = [[HeartRateBeat alloc] initWithBpm:beats
                                                         andZone:currentZone];
        [self.session addBeat:beat];
        
        self.currentZone = currentZone;
        
        if (currentZone) {
            //Send notification on zone change
            [self sendBeatNotification:beat
                             withSound:![currentZone.name isEqualToString:self.currentZone.name] && self.timer];
            self.zoneLabel.text = currentZone.name;
            
            //        NSLog(@"%@", currentZone);
            //TODO: Move color to zone
            switch (currentZone.heartZone) {
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
    }
    
    WEAK(self);
    [UIView animateWithDuration:1.f
                     animations:^{
                         weak_self.backgroundColor = background;
                         if (currentZone) {
                             self.tintColor = currentZone.heartZone == resting ? [UIColor heartRateRed] : [UIColor whiteColor];
                         }
                         else {
                             self.tintColor = [UIColor heartRateRed];
                         }
                         if (weak_self.navigationController == weak_self.viewDeckController.centerController) {
                             if (background == [UIColor whiteColor]) {
                                 [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
                             }
                             else {
                                 [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                             }
                         }
                         
                     }];
}

- (void)sendBeatNotification:(HeartRateBeat *)beat withSound:(BOOL)sound {
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateBackground) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil)
            return;
        localNotif.fireDate = [NSDate date];
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        
        // Notification details
        localNotif.alertBody = [NSString stringWithFormat:@"%@ - Zone %@ - %@ BPM", beat.rateZone.name, beat.rateZone.number, beat.bpm];
        if (sound) {
            localNotif.soundName = [NSString stringWithFormat:@"zone_%@.caf", beat.rateZone.number];
        }
        
        // Schedule the notification
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
    else {
        if (sound) {
            NSURL *soundURL = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"zone_%@", beat.rateZone.number]
                                                      withExtension:@"caf"];
            
            self.avSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
            [self.avSound play];
        }
    }
}

@end
