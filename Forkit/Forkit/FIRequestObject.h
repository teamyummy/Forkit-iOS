//
//  FIRequestObject.h
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import <Foundation/Foundation.h>
//PrimaryKey
typedef NSString PrimaryKey;

@interface FIRequestObject : NSObject

+ (void)requestRestaurantList;
+ (void)requestReviewListWithRestaurantPk:(PrimaryKey *)restaurantPk;
+ (void)requestDeleteReviewWithRestaurantPk:(PrimaryKey *)restaurantPk reviewPk:(PrimaryKey *)reviewPk;

+ (void)requestUploadReviewListWithRestaurantPk:(PrimaryKey *)restaurantPk image:(UIImage *)image contents:(NSString *)contents score:(NSInteger)score;
@end
