//
//  Created by Jonathan Grana on 11/21/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utility)

- (CGFloat)right;
- (void)setRight:(CGFloat)right;

- (CGFloat)left;
- (void)setLeft:(CGFloat)left;

- (CGFloat)top;
- (void)setTop:(CGFloat)top;

- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGPoint)boundsCenter;

- (void)applyRoundedCornersForCorners:(UIRectCorner)corners
                           withRadius:(CGFloat)radius;

@end
