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
                                                                 @{@"primaryKey":@"0", @"name":@"shop1", @"score":@"5", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5264", @"longitude":@"126.9569"},
                                                                 @{@"primaryKey":@"1", @"name":@"shop2", @"score":@"4", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5553", @"longitude":@"126.9269"},
                                                                 @{@"primaryKey":@"2", @"name":@"shop3", @"score":@"2", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5872", @"longitude":@"126.9770"},
                                                                 @{@"primaryKey":@"3", @"name":@"shop4", @"score":@"5", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5264", @"longitude":@"126.9639"},
                                                                 @{@"primaryKey":@"4", @"name":@"shop5", @"score":@"4", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5523", @"longitude":@"126.9169"},
                                                                 @{@"primaryKey":@"5", @"name":@"shop6", @"score":@"2", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5132", @"longitude":@"126.9070"},
                                                                 @{@"primaryKey":@"6", @"name":@"shop7", @"score":@"5", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5314", @"longitude":@"126.9129"},
                                                                 @{@"primaryKey":@"7", @"name":@"shop8", @"score":@"4", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5433", @"longitude":@"126.9439"},
                                                                 @{@"primaryKey":@"8", @"name":@"shop9", @"score":@"2", @"address":@"주소", @"review_count":@"72", @"favorite_count":@"25", @"latitude":@"37.5222", @"longitude":@"126.9220"}
                                                                 ]];
    }
    return self;
}

@end
