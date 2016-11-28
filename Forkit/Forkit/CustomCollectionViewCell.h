//
//  CustomCollectionViewCell.h
//  Forkit
//
//  Created by Nexus_MYT on 2016. 11. 29..
//  Copyright © 2016년 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell

@property UIImageView *customImageView;
@property UILabel *customTitleLabel;

- (instancetype)initWithFrame:(CGRect)frame;

@end
