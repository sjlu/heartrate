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
#import "UIColor+HeartRate.h"
#import "NSArray+HeartRate.h"
#import "HeartRateZone.h"
#import "UILabel+HeartRate.h"

@interface HeartBeatVerticalChart()

@property (nonatomic)       UIImageView         *imageHeart;
@property (nonatomic)       CGFloat             heartbeatSpeed;

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
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(self.width - 5.f, 0, 1.f, self.height)];
        verticalLine.backgroundColor = [UIColor heartRateRed];
        verticalLine.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubview:verticalLine];
        
        [self layoutPercentages];
        
        self.heartbeatSpeed = 1.f;
        [self startHeart];
    }
    return self;
}

- (void)layoutPercentages {
    NSArray *heartRateZones = [NSArray heartRateZones];
    
    for (HeartRateZone *zone in heartRateZones) {
        if (zone.percentage > 0) {
            UIView *horizontalDivider = [[UIView alloc] initWithFrame:CGRectMake(self.width - 5.f - self.width / 8, [self heightPositionForBPM:zone.minBPM], self.width / 8, 1.f)];
            horizontalDivider.backgroundColor = [UIColor heartRateRed];
            [self addSubview:horizontalDivider];
            UILabel *percentage = [[UILabel alloc]initWithFrame:CGRectMake(horizontalDivider.left - padding * 2, horizontalDivider.top - 8, padding * 2, padding * 2)];
            [percentage applyDefaultStyleWithSize:10.f];
            percentage.text = zone.percentageString;
            [percentage sizeToFit];
            percentage.textColor = [UIColor heartRateRed];
            percentage.right = horizontalDivider.left - 2;
            [self addSubview:percentage];
        }
    }
}

- (CGFloat)heightPositionForBPM:(NSNumber *)bpm; {
    NSNumber *maxHeartBpm = [NSUserDefaults getMaxHeartRate];
    CGFloat height = self.height - ((bpm.floatValue / maxHeartBpm.floatValue) * self.height);
    return height > 0 ? height : 0;
}

- (void)startHeart {
    [UIView animateKeyframesWithDuration:self.heartbeatSpeed
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:self.heartbeatSpeed/2 animations:^{
                                      
                                      self.imageHeart.transform = CGAffineTransformMakeScale(1.2, 1.2);
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:self.heartbeatSpeed relativeDuration:self.heartbeatSpeed animations:^{
                                      
                                      self.imageHeart.transform = CGAffineTransformMakeScale(1, 1);
                                  }];
                                  
                              } completion:^(BOOL finished) {
                                  [self startHeart];
                              }];
}

- (void)positionHeart:(NSNotification *)notification {
    NSNumber *bpm = notification.object;
    
    if (bpm.floatValue > 0) {
        self.heartbeatSpeed = 60 / bpm.floatValue;
    }
    
    NSLog(@"Heartbeat speed %f", self.heartbeatSpeed);
    WEAK(self);
    [UIView animateWithDuration:1
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         weak_self.imageHeart.bottom = [self heightPositionForBPM:bpm];
                     }
                     completion:nil];
    
}

- (UIImageView *)imageHeart {
    if (!_imageHeart) {
        UIImage *image = [UIImage named:@"heart"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _imageHeart = [[UIImageView alloc] initWithImage:image];
        _imageHeart.center = CGPointMake(padding / 2, self.height);
        [self addSubview:_imageHeart];
    }
    
    return _imageHeart;
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            label.textColor = tintColor;
        }
        else if ([subview isKindOfClass:[UIImageView class]]) {
            UIImageView *image = (UIImageView *)subview;
            image.tintColor = tintColor;
        }
        else {
            subview.backgroundColor = tintColor;
        }
    }
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
