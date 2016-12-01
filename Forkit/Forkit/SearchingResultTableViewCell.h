//
//  SearchingResultTableViewCell.h
//  Forkit
//
//  Created by Nexus_MYT on 2016. 12. 1..
//  Copyright © 2016년 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchingResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopAddressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *scoreImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopInfoDetailLabel;

@end
