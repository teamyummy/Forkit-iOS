//
//  CustomTableViewCell.m
//  Forkit
//
//  Created by Nexus_MYT on 2016. 12. 1..
//  Copyright © 2016년 david. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.customImageView = [[UIImageView alloc] init];
    self.customImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.customImageView];
    
    self.customTitleLabel = [[UILabel alloc] init];
    self.customTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.customImageView addSubview:self.customTitleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayout];
}

- (void)updateLayout {
    self.customImageView.frame = self.bounds;
    self.customTitleLabel.frame = CGRectMake(0, 0, 100, 30);
}

@end
