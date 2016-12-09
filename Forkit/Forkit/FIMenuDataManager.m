//
//  FIMenuDataManager.m
//  Forkit
//
//  Created by david on 2016. 12. 7..
//  Copyright © 2016년 david. All rights reserved.
//

#import "FIMenuDataManager.h"

@implementation FIMenuDataManager

+ (instancetype)sharedManager
{
    static FIMenuDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (void)setMenuDatas:(NSMutableArray *)menuDatas
{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *tempDict in menuDatas)
    {
        NSMutableDictionary *menuDict = [NSMutableDictionary new];
        
        //name
        [menuDict setValue:[tempDict objectForKey:JSONMenuNameKey]
                    forKey:JSONMenuNameKey];
        
        //price
        NSString *priceString = [FIUtilities changeCurrencyFormatFromNumber:[[tempDict objectForKey:JSONMenuPriceKey] integerValue] withCurrencyCode:nil];
        [menuDict setValue:priceString
                    forKey:JSONMenuPriceKey];
        
        //image
        [menuDict setValue:[tempDict objectForKey:JSONCommonThumbnailImageURLKey]
                    forKey:JSONCommonThumbnailImageURLKey];
        
        [tempArr addObject:menuDict];
    }
    _menuDatas = tempArr;
}

@end
