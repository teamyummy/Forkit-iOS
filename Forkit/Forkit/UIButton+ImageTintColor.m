//
//  UIButton+ImageTintColor.m
//  Forkit
//
//  Created by david on 2016. 12. 17..
//  Copyright © 2016년 david. All rights reserved.
//

#import "UIButton+ImageTintColor.h"

@implementation UIButton (ImageTintColor)

#pragma mark Background tint

- (void)setBackgroundTintColor:(UIColor *)color forState:(UIControlState)state
{
    if ([self backgroundImageForState:state])
        [self setBackgroundImage:[self tintedImageWithColor:color image:[self backgroundImageForState:state]] forState:state];
    else
        NSLog(@"%@ UIButton does not have any background image to tint.", self);
}

#pragma mark Tint method

- (UIImage *)tintedImageWithColor:(UIColor *)tintColor image:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // draw alpha-mask
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, image.CGImage);
    
    // draw tint color, preserving alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [tintColor setFill];
    CGContextFillRect(context, rect);
    
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return coloredImage;
}

@end
