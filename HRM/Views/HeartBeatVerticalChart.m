//
//  HeartBeatVerticalChart.m
//  heartrate
//
//  Created by Jonathan Grana on 11/24/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "HeartBeatVerticalChart.h"

#import "BluetoothManager.h"

#import "UIView+Utility.h"
#import "NSUserDefaults+HeartRate.h"
#import "UIImage+Factory.h"

@interface HeartBeatVerticalChart()

@property (nonatomic)       UIImageView         *imageHeart;

@end

@implementation HeartBeatVerticalChart

const static CGFloat padding = 16.f;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBluetoothNotificationHeartBeat object:nil];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(positionHeart:)
                                                     name:kBluetoothNotificationHeartBeat
                                                   object:nil];
    }
    return self;
}

- (void)positionHeart:(NSNotification *)notification {
    NSNumber *bpm = notification.object;
    NSNumber *maxHeartBpm = [NSUserDefaults getMaxHeartRate];
    
    WEAK(self);
    [UIView animateWithDuration:1
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         weak_self.imageHeart.center = CGPointMake(padding, weak_self.height - ((bpm.floatValue / maxHeartBpm.floatValue) * weak_self.height));
                     }
                     completion:nil];
    
}

- (UIImageView *)imageHeart {
    if (!_imageHeart) {
        UIImage *image = [UIImage named:@"heart"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _imageHeart = [[UIImageView alloc] initWithImage:image];
        _imageHeart.center = CGPointMake(padding, self.height);
        [self addSubview:_imageHeart];
    }
    
    return _imageHeart;
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    self.imageHeart.tintColor = tintColor;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
