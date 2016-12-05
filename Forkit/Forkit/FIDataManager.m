//
//  FIDataManager.m
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "FIDataManager.h"

@interface FIDataManager()

@end

@implementation FIDataManager

+ (instancetype)sharedManager {
    static FIDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shopDatas = [[NSMutableArray alloc] initWithArray:@[
                                                                 @{@"primaryKey":@"0", @"name":@"shoptype1", @"image":@"dummyFoodImage", @"score":@"5", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5264", @"longitude":@"126.9569"},
                                                                 @{@"primaryKey":@"1", @"name":@"shop2", @"image":@"dummyFoodImage", @"score":@"4", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5553", @"longitude":@"126.9269"},
                                                                 @{@"primaryKey":@"2", @"name":@"shoptype1", @"image":@"dummyFoodImage", @"score":@"2", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5872", @"longitude":@"126.9770"},
                                                                 @{@"primaryKey":@"3", @"name":@"shop4", @"image":@"dummyFoodImage", @"score":@"5", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5264", @"longitude":@"126.9639"},
                                                                 @{@"primaryKey":@"4", @"name":@"shoptype1", @"image":@"dummyFoodImage", @"score":@"4", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5523", @"longitude":@"126.9169"},
                                                                 @{@"primaryKey":@"5", @"name":@"shop6", @"image":@"dummyFoodImage", @"score":@"2", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5132", @"longitude":@"126.9070"},
                                                                 @{@"primaryKey":@"6", @"name":@"shop7", @"image":@"dummyFoodImage", @"score":@"5", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5314", @"longitude":@"126.9129"},
                                                                 @{@"primaryKey":@"7", @"name":@"shoptype1", @"image":@"dummyFoodImage", @"score":@"4", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5433", @"longitude":@"126.9439"},
                                                                 @{@"primaryKey":@"8", @"name":@"shop9", @"image":@"dummyFoodImage", @"score":@"2", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5222", @"longitude":@"126.9220"}
                                                                 ]];
    }
    return self;
}

- (NSArray *)searchName:(NSString *)name {
    NSMutableArray *searchResult = [[NSMutableArray alloc] init];
    //! containsString 을 사용하면 가게 명 뿐만 아니라 태그명, 주소, 점수 (범위) 검색 등도 가능하겠다
    for (NSDictionary *shopData in self.shopDatas) {
        if ([name containsString:shopData[@"name"]]) {
            [searchResult addObject:shopData];
        }
    }
    
    return searchResult;
}

@end
