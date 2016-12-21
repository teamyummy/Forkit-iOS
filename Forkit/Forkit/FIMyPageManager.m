//
//  FIMyPageManager.m
//  Forkit
//
//  Created by david on 2016. 12. 14..
//  Copyright © 2016년 david. All rights reserved.
//

#import "FIMyPageManager.h"

@implementation FIMyPageManager

+ (instancetype)sharedManager {
    static FIMyPageManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (void)setFavorShop:(NSMutableArray *)favorShop
{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *shopDict in favorShop)
    {
        NSMutableDictionary *tempDict = [NSMutableDictionary new];
        
        //pk
        NSString *primaryKey = [NSString stringWithFormat:@"%@", [shopDict objectForKey:JSONCommonPrimaryKey]];
        [tempDict setValue:primaryKey
                    forKey:JSONCommonPrimaryKey];
        
        //name
        [tempDict setValue:[shopDict objectForKey:JSONRestaurnatNameKey]
                    forKey:JSONRestaurnatNameKey];
        
        //address
        [tempDict setValue:[shopDict objectForKey:JSONRestaurnatAddressKey]
                    forKey:JSONRestaurnatAddressKey];
        
        //phone
        [tempDict setValue:[shopDict objectForKey:JSONRestaurnatPhoneNumberKey]
                    forKey:JSONRestaurnatPhoneNumberKey];
        
        //latitude
        [tempDict setValue:[shopDict objectForKey:JSONRestaurnatLatitudeKey]
                    forKey:JSONRestaurnatLatitudeKey];
        
        //longitude
        [tempDict setValue:[shopDict objectForKey:JSONRestaurnatLongitudeKey]
                    forKey:JSONRestaurnatLongitudeKey];
        
        //desc_parking
        [tempDict setValue:[shopDict objectForKey:JSONRestaurnatParkingDescriptionKey]
                    forKey:JSONRestaurnatParkingDescriptionKey];
        
        //desc_delivery
        [tempDict setValue:[shopDict objectForKey:JSONRestaurnatDeliveryDescriptionKey]
                    forKey:JSONRestaurnatDeliveryDescriptionKey];
        
        //operation_hour
        [tempDict setValue:[shopDict objectForKey:JSONRestaurnatOperationHourKey]
                    forKey:JSONRestaurnatOperationHourKey];
        
        //review_count
        NSNumber *reviewCount = [shopDict objectForKey:JSONRestaurnatTotalReviewCountKey];
        NSString *reviewCountString = [NSString stringWithFormat:@"%ld", [reviewCount integerValue]];
        [tempDict setValue:reviewCountString
                    forKey:JSONRestaurnatTotalReviewCountKey];
        
        //review_average
        NSNumber *averageNumber = [shopDict objectForKey:JSONRestaurnatAvgReviewScoreKey];
        NSString *averageString = [NSString stringWithFormat:@"%.1lf", [averageNumber floatValue]];
        [tempDict setValue:averageString
                    forKey:JSONRestaurnatAvgReviewScoreKey];
        
        //total_like
        NSNumber *totalLike = [shopDict objectForKey:JSONRestaurnatTotalLikeKey];
        NSString *totalLikeString = [NSString stringWithFormat:@"%ld", [totalLike integerValue]];
        [tempDict setValue:totalLikeString
                    forKey:JSONRestaurnatTotalLikeKey];
        
        //create date
        [tempDict setValue:[shopDict objectForKey:JSONCommonCreatedDateKey]
                    forKey:JSONCommonCreatedDateKey];
        
        //images
        [tempDict setValue:[shopDict objectForKey:JSONCommonImagesKey]
                    forKey:JSONCommonImagesKey];
        
        //tags
        [tempDict setValue:[shopDict objectForKey:JSONRestaurnatTagsKey]
                    forKey:JSONRestaurnatTagsKey];
        
        //my_like
        [tempDict setValue:[shopDict objectForKey:JSONRestaurnatMyLikeKey]
                    forKey:JSONRestaurnatMyLikeKey];
        
        //my_like_id
        NSNumber *likePk = [shopDict objectForKey:JSONRestaurnatMyLikePrimaryKey];
        NSString *likePkString = [NSString stringWithFormat:@"%ld", [likePk integerValue]];
        [tempDict setValue:likePkString
                    forKey:JSONRestaurnatMyLikePrimaryKey];
        
        //set data
        [tempArr addObject:tempDict];
    }
    _favorShop = tempArr;
}

- (void)setReviewDatas:(NSMutableArray *)reviewDatas
{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *reviewDict in reviewDatas)
    {
        NSMutableDictionary *tempDict = [NSMutableDictionary new];
        
        //author
        [tempDict setValue:[reviewDict objectForKey:JSONReviewAuthorKey]
                    forKey:JSONReviewAuthorKey];
        
        //content
        [tempDict setValue:[reviewDict objectForKey:JSONReviewContentKey]
                    forKey:JSONReviewContentKey];
        
        //score
        [tempDict setValue:[reviewDict objectForKey:JSONReviewScoreKey]
                    forKey:JSONReviewScoreKey];
        //id
        [tempDict setValue:[reviewDict objectForKey:JSONCommonPrimaryKey]
                    forKey:JSONCommonPrimaryKey];
        
        //images
        [tempDict setValue:[reviewDict objectForKey:JSONCommonImagesKey]
                    forKey:JSONCommonImagesKey];
        
        //created_date
        
        NSDateFormatter *parseDateFormat = [NSDateFormatter new];
        //correcting format to include seconds and decimal place
        NSString *input = [reviewDict objectForKey:JSONCommonCreatedDateKey];
        parseDateFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        // Always use this locale when parsing fixed format date strings
        NSDate *output = [parseDateFormat dateFromString:input];
        
        NSDateFormatter *parseStringFormat = [[NSDateFormatter alloc] init];
        [parseStringFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSString *iso8601String = [parseStringFormat stringFromDate:output];
        
        [tempDict setValue:iso8601String
                    forKey:JSONCommonCreatedDateKey];
        
        //rest_id
        if ([reviewDict objectForKey:JSONReviewRestaurantPrimaryKey] != nil)
        {
            NSNumber *restaurantPkNumber = [reviewDict objectForKey:JSONReviewRestaurantPrimaryKey];
            
            NSString *restaurantPkString = [NSString stringWithFormat:@"%ld", [restaurantPkNumber integerValue]];
            
            [tempDict setValue:restaurantPkString
                        forKey:JSONReviewRestaurantPrimaryKey];
        }

        //set data
        [tempArr addObject:tempDict];
    }
    _reviewDatas = tempArr;
}
@end
