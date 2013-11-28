#import "AppDelegate.h"

#import <HockeySDK/HockeySDK.h>

#import "HeartRateViewController.h"
#import "BluetoothManager.h"
#import "UINavigationController+Factory.h"
#import "UIColor+HeartRate.h"
#import "MenuTableViewController.h"
#import "IIViewDeckController.h"
#import "UIFont+HeartRate.h"

@interface AppDelegate()
<
BITHockeyManagerDelegate
>

@property (nonatomic) IIViewDeckController              *viewDeck;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setup];
    return YES;
}

- (void)setup {
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName           :   [UIColor whiteColor],
       NSFontAttributeName                      :   [UIFont defaultFontWithSize:22.f]
       }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    UINavigationController *nav = [UINavigationController navigationControllerWithController:[[HeartRateViewController alloc] init]];
    
    self.viewDeck = [[IIViewDeckController alloc] initWithCenterViewController:nav
                                                            leftViewController:[[MenuTableViewController alloc] init]];
    self.viewDeck.leftSize = 125.f;
    self.window.rootViewController = self.viewDeck;
    
#if REGISTER_HOCKEY
    [self registerHockey];
#endif
    
    //Initialize bluetooth manager
    [BluetoothManager shared];
}

- (void)registerHockey {
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"bcc85d573795f590465753c0b46b3210"
                                                           delegate:self];
    [[BITHockeyManager sharedHockeyManager] startManager];
}

@end
