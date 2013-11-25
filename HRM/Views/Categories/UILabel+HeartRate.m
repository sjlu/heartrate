#import "UILabel+HeartRate.h"

#import "UIColor+HeartRate.h"

@implementation UILabel (HeartRate)

- (void)applyDefaultStyleWithSize:(CGFloat)size {
    self.font = [UIFont fontWithName:@"Avenir" size:size];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor heartRateRed];
}

@end
