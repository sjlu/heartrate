#import "AppDelegate.h"

#import <HockeySDK/HockeySDK.h>

#import "HeartRateViewController.h"
#import "BluetoothManager.h"
#import "UINavigationController+Factory.h"
#import "UIColor+HeartRate.h"
#import "RESideMenu.h"
#import "MenuTableViewController.h"

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
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:nav
                                                                        menuViewController:[[MenuTableViewController alloc] init]];
    sideMenuViewController.contentViewInPortraitOffsetCenterX = 250;
//    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
//    sideMenuViewController.delegate = self;
    self.window.rootViewController = sideMenuViewController;
    
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

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController");
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController");
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController");
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController");
}

@end
