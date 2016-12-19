//
//  RestaurantDetailViewController.h
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantDetailViewController : UIViewController

@property NSMutableDictionary *restaurantDatas;
@property DidReceiveUpdateDataBlock didReceiveUpdateDataBlock;

@end
