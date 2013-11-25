#import "UINavigationController+Factory.h"

#import "UIColor+HeartRate.h"

@implementation UINavigationController (Factory)

+ (instancetype)navigationController {
    UINavigationController *nav = [[UINavigationController alloc] init];
    nav.navigationBar.backgroundColor = [UIColor clearColor];
    [nav.navigationBar setBackgroundImage:[UIImage new]
                            forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.shadowImage = [UIImage new];
    nav.navigationBar.translucent = YES;
    nav.navigationBar.tintColor = [UIColor heartRateRed];
    nav.view.backgroundColor = [UIColor clearColor];
    
    return nav;
}

@end
