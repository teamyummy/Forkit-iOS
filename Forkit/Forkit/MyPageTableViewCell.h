//
//  MyPageTableViewCell.h
//  Forkit
//
//  Created by david on 2016. 12. 4..
//  Copyright © 2016년 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPageTableViewCell : UITableViewCell

@end

@interface ProfileCell : MyPageTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@end

@interface ButtonCell : MyPageTableViewCell

//review button contents
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;

//like button contents
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@interface NotLoginCell : MyPageTableViewCell

@end

@interface LoginButtonCell : MyPageTableViewCell

@end
