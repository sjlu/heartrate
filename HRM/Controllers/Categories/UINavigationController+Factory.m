#import "UINavigationController+Factory.h"

#import "UIColor+HeartRate.h"
#import "UIImage+Factory.h"
#import "IIViewDeckController.h"
#import "HRMNavigationController.h"

@implementation UINavigationController (Factory)

+ (instancetype)navigationControllerWithController:(UIViewController *)controller {
    HRMNavigationController *nav = [[HRMNavigationController alloc] initWithRootViewController:controller];
    nav.navigationBar.backgroundColor = [UIColor clearColor];
    [nav.navigationBar setBackgroundImage:[UIImage new]
                            forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.shadowImage = [UIImage new];
    nav.navigationBar.translucent = YES;
    nav.navigationBar.tintColor = [UIColor whiteColor];
    
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage named:@"menu"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:controller.viewDeckController
                                                                            action:@selector(toggleLeftView)];
    
    return nav;
}

@end
