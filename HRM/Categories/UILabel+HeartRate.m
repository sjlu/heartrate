#import "UILabel+HeartRate.h"

@implementation UILabel (HeartRate)

- (void)applyDefaultStyleWithSize:(CGFloat)size {
    self.font = [UIFont fontWithName:@"Avenir" size:size];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor blackColor];
}

@end
