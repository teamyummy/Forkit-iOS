//
//  RoundButton.m
//  Forkit
//
//  Created by david on 2016. 12. 5..
//  Copyright © 2016년 david. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height/2;
}
@end

@implementation RoundColorButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end

@implementation LeftImageRightTitleButton

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self createButton];
}

- (void)createButton
{
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    CGSize titleLabelSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    CGFloat imageSize = 24.0f;
    CGFloat buttonWidth = self.frame.size.width;
    CGFloat buttonHeight = self.frame.size.height;
    CGFloat spacing = 4.0f;

    CGFloat buttonImageTopBottomInset = (buttonHeight - imageSize)/2.0f;
    CGFloat buttonLeftInset = (buttonWidth - (imageSize + titleLabelSize.width) - spacing) /2.0f;
    CGFloat buttonRightInset = buttonWidth - imageSize - buttonLeftInset;
    CGFloat titleEdgeInsetsRight = buttonLeftInset;
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(buttonImageTopBottomInset, buttonLeftInset, buttonImageTopBottomInset, buttonRightInset)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, titleEdgeInsetsRight)];
}
@end

@implementation RoundBorderLeftImageRightTitleButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.borderColor = [FIUtilities createGrayColor].CGColor;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self createButton];
    
}
- (void)createButton
{
    [super createButton];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = self.frame.size.height/2.0f;
}

@end
