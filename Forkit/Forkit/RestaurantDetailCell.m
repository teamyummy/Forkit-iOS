//
//  RestaurantDetailTitleCell.m
//  Forkit
//
//  Created by david on 2016. 11. 30..
//  Copyright © 2016년 david. All rights reserved.
//

#import "RestaurantDetailCell.h"
#import "RestaurantDetailViewController.h"

#pragma mark - Detail Cell Class
@implementation RestaurantDetailCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

#pragma mark - Title Cell Class
@implementation RestaurantDetailTitleCell

#pragma mark - Life Cycle
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self updateScoreViewToCircleView];
}

#pragma mark - Update View
- (void)updateScoreViewToCircleView
{
    CGFloat width = self.scoreView.frame.size.width;
    self.scoreView.layer.cornerRadius = width/2;
}

#pragma mark - Selected
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end

#pragma mark - Info Cell Class
@implementation RestaurantDetailInfoCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

#pragma mark - Deatail Title Cell Class
@implementation RestaurantDetailReviewTitleCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end

#pragma mark - Deatail Cell Class
@implementation RestaurantDetailReviewCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.reviewTextLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end

#pragma mark - Menu Cell Class
@implementation MenuCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
