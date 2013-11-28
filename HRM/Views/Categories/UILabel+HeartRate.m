#import "UILabel+HeartRate.h"

#import "UIColor+HeartRate.h"
#import "UIFont+HeartRate.h"

@implementation UILabel (HeartRate)

- (void)applyDefaultStyleWithSize:(CGFloat)size {
    self.font = [UIFont defaultFontWithSize:size];
    self.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor heartRateRed];
}

@end
