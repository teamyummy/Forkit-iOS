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

- (void)setShopDatas:(NSMutableArray *)shopDatas
{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *shopDict in shopDatas)
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
        
        //images
        [tempDict setValue:[shopDict objectForKey:JSONRestaurnatTagsKey]
                    forKey:JSONRestaurnatTagsKey];
        
        //set data
        [tempArr addObject:tempDict];
    }
    _favorShop = tempArr;
}
@end