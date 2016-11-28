//
//  CustomTitleLabel.m
//  Forkit
//
//  Created by Nexus_MYT on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "CustomTitleLabel.h"

@implementation CustomTitleLabel

- (instancetype)initWithTitle:(NSString *)title
                        frame:(CGRect)frame
                    textColor:(UIColor *)textColor
{
    self = [super init];
    if (self) {
        self.font = [UIFont boldSystemFontOfSize:30];
        self.textColor = textColor;
        self.text = title;
        self.textAlignment = NSTextAlignmentCenter;
        self.frame = frame;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
