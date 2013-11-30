#import "HeartRateViewController.h"

#import "UserInformationViewController.h"

#import "UILabel+HeartRate.h"
#import "UIImage+Factory.h"
#import "UIView+Utility.h"
#import "NSUserDefaults+HeartRate.h"
#import "UIColor+HeartRate.h"
#import "NSArray+HeartRate.h"
#import "UIViewController+HeartRate.h"
#import "UIButton+HeartRate.h"

#import "BluetoothManager.h"//Needed for constants

#import "HeartBeatVerticalChart.h"
#import "HeartRateContainer.h"

#import "HeartRateZone.h"
#import "HeartRateSession.h"
#import "HeartRateBeat.h"

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


//TODO: Update Vertical Chart, zones and status
@property (nonatomic)   HeartBeatVerticalChart      *heartVerticalChart;
@property (nonatomic)   UILabel                     *statusLabel;
@property (nonatomic)   UILabel                     *zoneLabel;

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
    
    [self.view addSubview:self.heartRateContainer];
    
    self.heartVerticalChart = [[HeartBeatVerticalChart alloc] initWithFrame:CGRectMake(self.view.width - 32.f, 64.f, 32.f, self.view.height - 64.f - padding * 1.5)];
    [self.view addSubview:self.heartVerticalChart];
    
    self.startButton = [UIButton defaultButtonWithFrame:CGRectMake(-1, self.view.height - padding * 1.5, self.view.width / 2 + 2, padding * 1.5 + 1) andTitle:NSLocalizedString(@"Start", nil)];
    self.startButton.layer.borderWidth = 1.f;
    self.startButton.layer.borderColor = [UIColor heartRateRed].CGColor;
    [self.startButton addTarget:self
                         action:@selector(toggleTime)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startButton];
    
    self.resetButton = [UIButton defaultButtonWithFrame:CGRectMake(self.view.width / 2, self.view.height - padding * 1.5, self.view.width / 2 + 1, padding * 1.5 + 1) andTitle:NSLocalizedString(@"Reset", nil)];
    self.resetButton.layer.borderWidth = 1.f;
    self.resetButton.layer.borderColor = [UIColor heartRateRed].CGColor;
    [self.resetButton addTarget:self
                         action:@selector(resetTime)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.resetButton];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    [self.timeLabel applyDefaultStyleWithSize:40.f];
    self.timeLabel.text = @"00:00";
    [self.view addSubview:self.timeLabel];
    
    self.averageLabel = [[UILabel alloc] initWithFrame:CGRectMake(-1, self.timeLabel.bottom, self.view.width / 2 + 2, 54.f)];
    [self.averageLabel applyDefaultStyleWithSize:30.f];
    self.averageLabel.text = @"0";
//    self.averageLabel.layer.borderWidth = 1.f;
//    self.averageLabel.layer.borderColor = [UIColor heartRateRed].CGColor;
    [self.view addSubview:self.averageLabel];
    
    UILabel *averageTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.averageLabel.bottom - self.averageLabel.height / 2.5, self.averageLabel.width, self.averageLabel.height / 2)];
    [averageTitleLable applyDefaultStyleWithSize:12.f];
    averageTitleLable.text = NSLocalizedString(@"Average BPM", nil);
    [self.view addSubview:averageTitleLable];
    
    self.caloriesLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width / 2-1, self.timeLabel.bottom, self.view.width / 2 + 2, 54.f)];
    [self.caloriesLabel applyDefaultStyleWithSize:30.f];
    self.caloriesLabel.text = @"0";
    //    self.averageLabel.layer.borderWidth = 1.f;
    //    self.averageLabel.layer.borderColor = [UIColor heartRateRed].CGColor;
    [self.view addSubview:self.caloriesLabel];
    
    UILabel *calorieTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(self.caloriesLabel.left, self.caloriesLabel.bottom - self.caloriesLabel.height / 2.5, self.caloriesLabel.width, self.caloriesLabel.height / 2)];
    [calorieTitleLable applyDefaultStyleWithSize:12.f];
    calorieTitleLable.text = NSLocalizedString(@"Calories Burned", nil);
    [self.view addSubview:calorieTitleLable];
    
    
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
            //Ask user to fill out profile
            
            //[weak_self toggleSettings];
        }
    });
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
    [self.zoneLabel.layer addAnimation:self.textAnimation forKey:@"changeTextTransition"];
    self.heartRateLabel.text = [NSString stringWithFormat:@"%@", beats];
    
    HeartRateZone *currentZone = [[NSArray heartRateZones] currentZoneForBPM:beats];
    [self.session addBeat:[[HeartRateBeat alloc] initWithBpm:beats
                                                     andZone:currentZone]];
    
    if ([currentZone.name isEqualToString:self.currentZone.name]) {
        [self sendZoneNotification:currentZone];
    }
    self.currentZone = currentZone;
    
    UIColor *background = [UIColor whiteColor];
    
    if (currentZone) {
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
    
    WEAK(self);
    [UIView animateWithDuration:1.f
                     animations:^{
                         self.tintColor = currentZone.zone == resting ? [UIColor heartRateRed] : [UIColor whiteColor];
                         weak_self.backgroundColor = background;
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
    if (state == UIApplicationStateBackground)
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
