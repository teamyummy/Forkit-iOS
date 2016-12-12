//
//  RestaurantListCollectionViewCell.m
//  Forkit
//
//  Created by david on 2016. 12. 11..
//  Copyright © 2016년 david. All rights reserved.
//

#import "RestaurantListCollectionViewCell.h"

@implementation RestaurantListCollectionViewCell

- (void)awakeFromNib
{
    self.restaurantRoundView.layer.cornerRadius = 2.5;
    self.backgroundColor = [UIColor clearColor];
    [super awakeFromNib];
}

@end
