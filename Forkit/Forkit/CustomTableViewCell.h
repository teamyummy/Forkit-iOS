//
//  CustomTableViewCell.h
//  Forkit
//
//  Created by Nexus_MYT on 2016. 12. 1..
//  Copyright © 2016년 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property UIImageView *customImageView;
@property UILabel *customTitleLabel;

- (instancetype)initWithFrame:(CGRect)frame;

@end
