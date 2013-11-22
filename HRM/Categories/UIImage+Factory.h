//
//  Created by Jonathan Grana on 11/21/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Factory)

/**
 *  Extra checks on imageNamed
 *
 *  @param imageName name of image
 *
 *  @return UIImage of given name
 */
+ (UIImage *)named:(NSString *)imageName;


+ (UIImage *)imageWithColor:(UIColor *)color
                    andSize:(CGSize)size;

/**
 *  Because who needs graphic designers for flat ui
 *
 *  @param color        color of the image
 *  @param cornerRadius corner radius of the image
 *
 *  @return UIImage of given color
 */
+ (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(CGFloat)cornerRadius;

/**
 *  Creates an image with a shadow
 *
 *  @param image        the image to add a shadow to
 *  @param cornerRadius the cornerradius of the image
 *  @param shadowColor  the color of the shadow
 *  @param shadowInsets the size of the shadow
 *
 *  @return UIImage with shadow added
 */
+ (UIImage *) shadowImageWithImage:(UIImage*)image
                      cornerRadius:(CGFloat)cornerRadius
                       shadowColor:(UIColor *)shadowColor
                      shadowInsets:(UIEdgeInsets)shadowInsets;

/**
 *  Creates a background image with a shadow given a color
 *
 *  @param color        color of the image
 *  @param cornerRadius corner radius of the image
 *  @param shadowColor  color of the shadow
 *  @param shadowInsets height of the shadow
 *
 *  @return UIImage with color and shadow
 */
+ (UIImage *) buttonImageWithColor:(UIColor *)color
                      cornerRadius:(CGFloat)cornerRadius
                       shadowColor:(UIColor *)shadowColor
                      shadowInsets:(UIEdgeInsets)shadowInsets;

@end
