//
//  SearchingResultTableViewCell.m
//  Forkit
//
//  Created by Nexus_MYT on 2016. 12. 1..
//  Copyright © 2016년 david. All rights reserved.
//

#import "SearchingResultTableViewCell.h"

@implementation SearchingResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayout];
}

- (void)updateLayout {
    self.imageView.frame = CGRectMake(8, 8, 120, 120);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
