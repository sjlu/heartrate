#import "AppDelegate.h"

#import <HockeySDK/HockeySDK.h>

#import "HeartRateViewController.h"
#import "BluetoothManager.h"
#import "UINavigationController+Factory.h"

@interface AppDelegate()
<
BITHockeyManagerDelegate
>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setup];
    return YES;
}

- (void)setup {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    UINavigationController *nav = [UINavigationController navigationController];
    [nav setViewControllers:@[[[HeartRateViewController alloc] init]]];
    self.window.rootViewController = nav;
    
    [self registerHockey];
    
    //Initialize bluetooth manager
    [BluetoothManager shared];
}

- (void)registerHockey {
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"bcc85d573795f590465753c0b46b3210"
                                                           delegate:self];
    [[BITHockeyManager sharedHockeyManager] startManager];
}

@end
