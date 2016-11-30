//
//  CustomUIView.m
//  Forkit
//
//  Created by david on 2016. 11. 29..
//  Copyright © 2016년 david. All rights reserved.
//

#import "CustomUIView.h"

static NSString *const bottomBorderView = @"bottomBorderView";
static NSString *const rightBorderView = @"rightBorderView";

@implementation CustomUIView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setRightBorderWithStroke:0.75 alpha:0.18];
}

- (void)setRightBorderWithStroke:(CGFloat)stroke alpha:(CGFloat)alpha
{
    CALayer *border = [CALayer layer];
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    
    if ([self.restorationIdentifier isEqualToString:bottomBorderView])
    {
        border.frame = CGRectMake(0, height-stroke, width, stroke);
    } else if ([self.restorationIdentifier isEqualToString:rightBorderView])
    {
        border.frame = CGRectMake(width, 0, stroke, height);
    }
    UIColor *color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:alpha];
    
    border.backgroundColor = color.CGColor;
    
    [self.layer addSublayer:border];
}

@end
