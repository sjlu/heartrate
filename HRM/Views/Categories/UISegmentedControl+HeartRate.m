#import "UISegmentedControl+HeartRate.h"

#import "UIColor+HeartRate.h"
#import "UIFont+HeartRate.h"

@implementation UISegmentedControl (HeartRate)

+ (instancetype)defaultSegmentedControlWithItems:(NSArray *)items {
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:items];
    segment.tintColor = [UIColor whiteColor];
    UIFont *font = [UIFont defaultFontWithSize:22.0f];
    NSDictionary *attributes = @{
                                 NSFontAttributeName : font
                                 };
    [segment setTitleTextAttributes:attributes
                           forState:UIControlStateNormal];
    
    for (int i = 0; i < items.count; i++) {
        [segment setContentOffset:CGSizeMake(0, 3) forSegmentAtIndex:i];
    }
    
    return segment;
}

@end
