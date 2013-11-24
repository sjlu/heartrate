#import "HeartRateViewController.h"

#import "UserInformationViewController.h"

#import "UILabel+HeartRate.h"
#import "UIImage+Factory.h"
#import "UIView+Utility.h"
#import "NSUserDefaults+HeartRate.h"

#import "BluetoothManager.h"//Needed for constants

#import "HeartBeatVerticalChart.h"

@interface HeartRateViewController ()

@property (nonatomic)   UILabel                     *heartRateLabel;
@property (nonatomic)   UILabel                     *zoneLabel;
@property (nonatomic)   UILabel                     *statusLabel;
@property (nonatomic)   HeartBeatVerticalChart      *heartVerticalChart;

@end

@implementation HeartRateViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBluetoothNotificationHeartBeat object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage named:@"settings"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(showSettings)];
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor clearColor];
    
    //TODO: Change all strings to NSLocalizedString Macro
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 165, self.view.width, 150)];
    [self.statusLabel applyDefaultStyleWithSize:32.f];
    self.statusLabel.text = @"Searching...";
    [self.view addSubview:self.statusLabel];
    
    self.heartRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 165, self.view.width, 150)];
    [self.heartRateLabel applyDefaultStyleWithSize:144.f];
    self.heartRateLabel.text = @"...";
    [self.view addSubview:self.heartRateLabel];
    
    self.zoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.heartRateLabel.bottom + 40, self.view.width, 40)];
    [self.zoneLabel applyDefaultStyleWithSize:34.f];
    [self.view addSubview:self.zoneLabel];
    
    self.heartVerticalChart = [[HeartBeatVerticalChart alloc] initWithFrame:CGRectMake(self.view.width - 32.f, 0, 32.f, self.view.height)];
    [self.view addSubview:self.heartVerticalChart];
    
    //Observe heart beat updates
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateWithBPM:)
                                                 name:kBluetoothNotificationHeartBeat
                                               object:nil];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    WEAK(self);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSNumber *maxHeartRate = [NSUserDefaults getMaxHeartRate];
        if (maxHeartRate.intValue >= 220) {
            [weak_self showSettings];
        }
    });
}

#pragma mark - Selector Methods

- (void)showSettings {
    [self.navigationController pushViewController:[[UserInformationViewController alloc] init] animated:YES];
}

- (void)updateWithBPM:(NSNotification *)notification {
    NSNumber *beats = notification.object;
    self.heartRateLabel.text = [NSString stringWithFormat:@"%@", beats];
    
    NSNumber *maxHeartRate = [NSUserDefaults getMaxHeartRate];
    
    if (maxHeartRate.intValue < 220) {
        const uint16_t max_bpm = maxHeartRate.unsignedShortValue;
        const uint16_t bpm = beats.unsignedShortValue;
        
        //TODO: Move colors to category class
        if (bpm > max_bpm) {
            self.zoneLabel.text = @"Max";
            self.view.backgroundColor = [UIColor colorWithRed:(122/255.f) green:(43/255.f) blue:(53/255.f) alpha:1];
            self.tintColor = [UIColor whiteColor];
        } else if (bpm > max_bpm-20) {
            self.zoneLabel.text = @"Anaerobic";
            self.view.backgroundColor = [UIColor colorWithRed:(122/255.f) green:(43/255.f) blue:(53/255.f) alpha:1];
            self.tintColor = [UIColor whiteColor];
        } else if (bpm > max_bpm-40) {
            self.zoneLabel.text = @"Aerobic";
            self.view.backgroundColor = [UIColor colorWithRed:(98/255.f) green:(111/255.f) blue:(145/255.f) alpha:1];
            self.tintColor = [UIColor whiteColor];
        } else if (bpm > max_bpm-60) {
            self.zoneLabel.text = @"Weight Control";
            self.view.backgroundColor = [UIColor colorWithRed:(98/255.f) green:(111/255.f) blue:(145/255.f) alpha:1];
            self.tintColor = [UIColor whiteColor];
        } else if (bpm > max_bpm-80) {
            self.zoneLabel.text = @"Moderate";
            self.view.backgroundColor = [UIColor colorWithRed:(127/255.f) green:(164/255.f) blue:(116/255.f) alpha:1];
            self.tintColor = [UIColor whiteColor];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        } else {
            self.zoneLabel.text = @"Resting";
            self.view.backgroundColor = [UIColor whiteColor];
            self.tintColor = [UIColor redColor];
        }
    }
    else {
        self.zoneLabel.text = @"";
        self.view.backgroundColor = [UIColor whiteColor];
        self.tintColor = [UIColor colorWithRed:(122/255.f) green:(43/255.f) blue:(53/255.f) alpha:1];
    }
    
    
    self.statusLabel.text = @"";
}

- (void)setTintColor:(UIColor *)tintColor {
    self.navigationController.navigationBar.tintColor = tintColor;
    self.heartVerticalChart.tintColor = tintColor;
    self.zoneLabel.textColor= tintColor;
    self.heartRateLabel.textColor = tintColor;
    
}

@end
