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
