//
//  RoundImageView.m
//  Forkit
//
//  Created by david on 2016. 12. 4..
//  Copyright © 2016년 david. All rights reserved.
//

#import "RoundImageView.h"

@implementation RoundImageView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = self.frame.size.height/2;
}

@end
