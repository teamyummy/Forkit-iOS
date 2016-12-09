//
//  FIReviewManager.m
//  Forkit
//
//  Created by david on 2016. 12. 7..
//  Copyright © 2016년 david. All rights reserved.
//

#import "FIReviewDataManager.h"

@implementation FIReviewDataManager

+ (instancetype)sharedManager
{
    static FIReviewDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
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
        
        //set data
        [tempArr addObject:tempDict];
    }
    _reviewDatas = tempArr;
}
@end
