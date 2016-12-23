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
static NSString *const borderView = @"borderView";

@implementation CustomUIView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
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
    } else if ([self.restorationIdentifier isEqualToString:borderView])
    {
        [self setBorderWithStroke:stroke alpha:alpha];
        return;
    }
    UIColor *color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:alpha];
    
    border.backgroundColor = color.CGColor;
    
    [self.layer addSublayer:border];
}

- (void)setBorderWithStroke:(CGFloat)stroke alpha:(CGFloat)alpha
{
    self.layer.borderWidth = stroke;
    UIColor *color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:alpha];
    self.layer.borderColor = color.CGColor;
}
@end

@implementation RoundView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.layer.cornerRadius = self.frame.size.height/2;
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [FIUtilities createGrayColor].CGColor;
}

@end

@interface BottomBorderView()

@property (nonatomic,getter=isDrawBorder)BOOL drawBorder;

@end

@implementation BottomBorderView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (![self isDrawBorder])
    {
        [self setBorderWithStroke:0.75 alpha:0.18];
    }
}

- (void)setBorderWithStroke:(CGFloat)stroke alpha:(CGFloat)alpha
{
    self.drawBorder = YES;
    CALayer *bottomLayer = [CALayer layer];
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    
    bottomLayer.frame = CGRectMake(0, height-stroke, width, stroke);
    UIColor *color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:alpha];
    
    bottomLayer.backgroundColor = color.CGColor;
    
    [self.layer addSublayer:bottomLayer];
}

@end
