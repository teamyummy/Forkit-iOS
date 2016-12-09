//
//  CustomTableViewCell.m
//  Forkit
//
//  Created by Nexus_MYT on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "RestaurantListCell.h"

@implementation RestaurantListCell

- (void)awakeFromNib
{
    self.restaurantRoundView.layer.cornerRadius = 2.5;
    self.backgroundColor = [UIColor clearColor];
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
