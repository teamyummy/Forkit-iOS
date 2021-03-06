//
//  FIRequestObject.m
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "FIRequestObject.h"
#import <AFNetworking.h>
#import "FILoginManager.h"
#import "HomeViewController.h"

//Request Type
typedef NS_ENUM(NSInteger, RequestType)
{
    RequestTypeRestaurantList,
    RequestTypeReviewList,
    RequestTypeReviewDetail,
    RequestTypeMenuList,
    RequestTypeLoginToken,
    RequestTypeMyLikeRestaurant,
    RequestTypeMyReview,
    RequestTypeFavor
};

//URL Name
static NSString *const URLNameRestaurants = @"restaurants/";
static NSString *const URLNameReviews = @"reviews/";
static NSString *const URLNameMenus = @"menus/";
static NSString *const URLNameLogin = @"token-auth/";
static NSString *const URLNameMyLikeRestaurant = @"/my/favor-rests/";
static NSString *const URLNameMyReview = @"my/author-reviews/";
static NSString *const URLNameFavor = @"favors/";

//Prameter Name
static NSString *const ParamNameUserIDKey = @"username";
static NSString *const ParamNameUserPWKey = @"password";
static NSString *const ParamNameLoginTokenKey = @"Authorization";
static NSString *const ParamNameReviewImageKey = @"img";
static NSString *const ParamNameReviewImagesKey = @"imgs";
static NSString *const ParamNameReviewAltKey = @"alt";
static NSString *const ParamNameReviewAltsKey = @"alts";

//Base URL String
static NSString *const BaseURLString = @"http://mangoplates.com/";
static NSString *const BasePathString = @"api/v1/";

@implementation FIRequestObject


//create URLString
+ (NSString *)requestURLString:(RequestType)type restaurantPk:(PrimaryKey *)restaurantPk reviewPk:(PrimaryKey *)reviewPk
{
    NSMutableString *URLString = [BaseURLString mutableCopy];
    [URLString appendString:BasePathString];
    
    
    if (type == RequestTypeLoginToken)
    {//Restaurant List
        [URLString appendString:URLNameLogin];
        return URLString;
        
    } else if (type == RequestTypeMyLikeRestaurant)
    {//My Like Restaurant
        [URLString appendString:URLNameMyLikeRestaurant];
        return URLString;
        
    } else if (type == RequestTypeMyReview)
    {//My Review
        [URLString appendString:URLNameMyReview];
        return URLString;
        
    } else
    {
        if (type == RequestTypeRestaurantList)
        {
            [URLString appendString:URLNameRestaurants];
            return URLString;
        }
        [URLString appendString:URLNameRestaurants];
        [URLString appendString:[NSString stringWithFormat:@"%@/", restaurantPk]];
        
        switch (type)
        {//Review List
            case RequestTypeReviewList:
                [URLString appendString:URLNameReviews];
                break;
         //Review Deatail
            case RequestTypeReviewDetail:
                [URLString appendString:URLNameReviews];
                [URLString appendString:[NSString stringWithFormat:@"%@/", reviewPk]];
                break;
         //Menu List
            case RequestTypeMenuList:
                [URLString appendString:URLNameMenus];
                break;
         //Login
            case RequestTypeLoginToken:
                [URLString appendString:URLNameLogin];
                break;
        //Favor
            case RequestTypeFavor:
                [URLString appendString:URLNameFavor];
                break;
                
            default:
                NSLog(@"요청한 URL이 없습니다");
                return nil;
                break;
        }
    }
    return URLString;
}
/*
 모든 음식점 리스트 (GET)
 */
+ (void)requestRestaurantList
{
    //URL String
    NSString *URLString = [FIRequestObject requestURLString:RequestTypeRestaurantList
                                               restaurantPk:nil
                                                   reviewPk:nil];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    if ([FILoginManager isOnLogin])
    {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:[[FILoginManager sharedManager] loginToken] forHTTPHeaderField:ParamNameLoginTokenKey];
    }
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:URLString
      parameters:[[FIDataManager sharedManager] restaurantSortingParamDict]
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             [[FIDataManager sharedManager] setShopDataDict:responseObject];
             [[FIDataManager sharedManager] setShopDatas:[NSMutableArray arrayWithArray: [responseObject objectForKey:JSONRestaurantResultsKey]]];
             
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"%@", error);
         }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}
/*
 모든 음식점 리스트, 정렬, 검색 (GET)
 */
+ (void)requestRestaurantList:(NSDictionary *)paramDict pagingURLString:(NSString *)pagingURLString isPaging:(BOOL)isPaging isSearch:(BOOL)isSearch didReceiveUpdateDataBlock:(DidReceiveUpdateDataBlock)didReceiveUpdateDataBlock
{
    //URL String
    NSString *URLString = [FIRequestObject requestURLString:RequestTypeRestaurantList
                                             restaurantPk:nil
                                                   reviewPk:nil];
    
    if (pagingURLString != nil)
    {//paging
        URLString = pagingURLString;
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    if ([FILoginManager isOnLogin])
    {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:[[FILoginManager sharedManager] loginToken] forHTTPHeaderField:ParamNameLoginTokenKey];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:URLString
      parameters:paramDict
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             if (isSearch)
             {
                 [[FISearchManager sharedManager] setSearchShopDatas:[responseObject objectForKey:JSONRestaurantResultsKey]];
             } else
             {
                 [[FIDataManager sharedManager] setShopDataDict:responseObject isPaging:isPaging];
             }
             if (didReceiveUpdateDataBlock != nil)
             {
                 didReceiveUpdateDataBlock();
             }
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"%@", error);
         }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

/*
 특정 음식점에 따른 메뉴 리스트 (GET)
 */
+ (void)requestMenuListWithRestaurantPk:(PrimaryKey *)restaurantPk didReceiveUpdateDataBlock:(DidReceiveUpdateDataBlock)didReceiveUpdateDataBlock
{
    //URL String
    NSString *URLString = [FIRequestObject requestURLString:RequestTypeMenuList
                                               restaurantPk:restaurantPk
                                                   reviewPk:nil];
    
    //Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    request.HTTPMethod = @"GET";
    
    //Session
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //Data Task
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                    if (error != nil)
                                                    {
                                                        NSLog(@"Error occured : %@",error);
                                                    }
                                                    if (responseObject == nil)
                                                    {
                                                        NSLog(@"Data dosen't exist");
                                                    }else
                                                    {
                                                        //responseObject를 menu manager에 저장
                                                        [[FIMenuDataManager sharedManager] setMenuDatas:responseObject];
                                                        
                                                        didReceiveUpdateDataBlock();
                                                    }
                                                }];
    
    [dataTask resume];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


/*
 특정 음식점에 따른 리뷰 리스트 (GET)
 */
+ (void)requestReviewListWithRestaurantPk:(PrimaryKey *)restaurantPk didReceiveUpdateDataBlock:(DidReceiveUpdateDataBlock)didReceiveUpdateDataBlock
{
    //URL String
    NSString *URLString = [FIRequestObject requestURLString:RequestTypeReviewList
                                               restaurantPk:restaurantPk
                                                   reviewPk:nil];
    
    //Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    request.HTTPMethod = @"GET";
    
    //Session
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //Data Task
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                    if (error != nil)
                                                    {
                                                        NSLog(@"Error occured : %@",error);
                                                    }
                                                    if (responseObject == nil)
                                                    {
                                                        NSLog(@"Data dosen't exist");
                                                    }else
                                                    {
                                                        //responseObject를 review manager에 저장
                                                        [[FIReviewDataManager sharedManager] setReviewDatas:[NSMutableArray arrayWithArray:responseObject]];
                                                        didReceiveUpdateDataBlock();
                                                    }
                                                }];
    
    [dataTask resume];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

/*
 특정 음식점에 따른 리뷰 텍스트 등록 (POST)
 */
+ (void)requestUploadReviewListWithRestaurantPk:(PrimaryKey *)restaurantPk images:(NSArray *)images contents:(NSString *)contents score:(NSInteger)score didReceiveUpdateDataBlock:(DidReceiveUpdateDataBlock)didReceiveUpdateDataBlock
{
    //create URL
    NSString *requsetURL = [FIRequestObject requestURLString:RequestTypeReviewList
                                                restaurantPk:restaurantPk
                                                    reviewPk:nil];
    
    //manager
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[[FILoginManager sharedManager] loginToken] forHTTPHeaderField:ParamNameLoginTokenKey];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //param
    NSMutableDictionary *bodyParms = [NSMutableDictionary dictionary];
    [bodyParms setObject:contents forKey:JSONReviewContentKey];
    [bodyParms setObject:@"ioschef review" forKey:JSONReviewTitleKey];
    [bodyParms setObject:[NSNumber numberWithInteger:score] forKey:JSONReviewScoreKey];
    for (NSInteger i = 0; i < images.count; i++)
    {
        [bodyParms setObject:@"alt" forKey:ParamNameReviewAltsKey];
    }
    
    //post
    [manager POST:requsetURL
       parameters:bodyParms
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
    [formData appendPartWithFormData:[contents dataUsingEncoding:NSUTF8StringEncoding] name:JSONReviewContentKey];
    
    [formData appendPartWithFormData:[@"ioschef review" dataUsingEncoding:NSUTF8StringEncoding] name:JSONReviewTitleKey];
    
    [formData appendPartWithFormData:[[NSString stringWithFormat:@"%ld",score] dataUsingEncoding:NSUTF8StringEncoding] name:JSONReviewScoreKey];
    
    for (UIImage *image in images)
    {
            [formData appendPartWithFormData:[@"alt" dataUsingEncoding:NSUTF8StringEncoding] name:ParamNameReviewAltsKey];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.7)
                                        name:ParamNameReviewImagesKey
                                    fileName:@"image.jpeg"
                                    mimeType:@"image/jpeg"];
    }
    
}
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              [FIRequestObject requestRestaurantDetailDataWithRestaurantPk:restaurantPk didReceiveUpdateDataBlock:didReceiveUpdateDataBlock];
              [FIRequestObject requestMyRegisterReview];
              [FIRequestObject requestMyFavorRestaurantList];
              [FIRequestObject requestRestaurantList];
    
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@",error);
          }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

/*
 특정 음식점에 따른 특정 리뷰 (DELETE)
 */
+ (void)requestDeleteReviewWithRestaurantPk:(PrimaryKey *)restaurantPk reviewPk:(PrimaryKey *)reviewPk isMypageVC:(BOOL)isMypageVC didReceiveUpdateDataBlock:(DidReceiveUpdateDataBlock)didReceiveUpdateDataBlock
{
    //URL String
    NSString *URLString = [FIRequestObject requestURLString:RequestTypeReviewDetail
                                               restaurantPk:restaurantPk
                                                   reviewPk:reviewPk];
    
    //Request
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[[FILoginManager sharedManager] loginToken] forHTTPHeaderField:ParamNameLoginTokenKey];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager DELETE:URLString
         parameters:nil
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                if (isMypageVC == NO)
                {
                    [FIRequestObject requestRestaurantDetailDataWithRestaurantPk:restaurantPk didReceiveUpdateDataBlock:didReceiveUpdateDataBlock];
                } else
                {
                    [FIRequestObject requestMyRegisterReview];
                    [FIRequestObject requestMyFavorRestaurantList];
                    [FIRequestObject requestRestaurantList];
                }
                
                NSLog(@"responseObject : %@",responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


/*
 로그인 (POST)
 */
+ (void)requestLoginTokenWithUserId:(NSString *)userId userPw:(NSString *)userPw success:(DidReceiveSuccessLoginBlock)success failed:(DidReceiveFailedLoginBlock)failed
{    
    //create URL
    NSString *requsetURL = [FIRequestObject requestURLString:RequestTypeLoginToken
                                                restaurantPk:nil
                                                    reviewPk:nil];
    
    //create bodyParms
    NSMutableDictionary *bodyParms = [NSMutableDictionary dictionary];

    [bodyParms setObject:userId forKey:ParamNameUserIDKey];
    [bodyParms setObject:userPw forKey:ParamNameUserPWKey];
    
    //create Request
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:requsetURL
                                                                                             parameters:bodyParms
                                                                              constructingBodyWithBlock:nil
                                                                                                  error:nil];
    
    //create URLSession
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    id uploadTaskHandler = ^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSArray *resposeArr = [responseObject allKeys];
        for (NSString *responseStr in resposeArr)
        {
            if ([responseStr isEqualToString:@"token"])
            {//success login
                NSString *token = [responseObject objectForKey:responseStr];
                NSString *loginToken = [NSString stringWithFormat:@"Token %@",token];
                [[FILoginManager sharedManager] setLoginToken:loginToken];
                [FILoginManager setLoginState];
                [[FILoginManager sharedManager] setUserId:userId];
                success();
            } else
            {//failed login
                failed();
            }
        }
    };
    
    //create UploadTask
    NSURLSessionDataTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                     progress:nil
                                                            completionHandler:uploadTaskHandler];
    [uploadTask resume];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

/*
 나의 즐겨찾기 식당(GET)
 */
+ (void)requestMyFavorRestaurantList
{
    //URL String
    NSString *URLString = [FIRequestObject requestURLString:RequestTypeMyLikeRestaurant
                                               restaurantPk:nil
                                                   reviewPk:nil];
    
    //Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    request.HTTPMethod = @"GET";
    [request setValue:[[FILoginManager sharedManager] loginToken] forHTTPHeaderField:ParamNameLoginTokenKey];
    
    //Session
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //Data Task
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                    if (error != nil)
                                                    {
                                                        NSLog(@"Error occured : %@",error);
                                                    }
                                                    if (responseObject == nil)
                                                    {
                                                        NSLog(@"Data dosen't exist");
                                                    }else
                                                    {
                                                        //responseObject를 my favor list manager에 저장
                                                        [[FIMyPageManager sharedManager] setFavorShop:[NSMutableArray arrayWithArray: responseObject]];
                                                    }
                                                }];
    [dataTask resume];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

/*
 나의 리뷰(GET)
 */
+ (void)requestMyRegisterReview
{
    //URL String
    NSString *URLString = [FIRequestObject requestURLString:RequestTypeMyReview
                                               restaurantPk:nil
                                                   reviewPk:nil];
    
    //Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    request.HTTPMethod = @"GET";
    [request setValue:[[FILoginManager sharedManager] loginToken] forHTTPHeaderField:ParamNameLoginTokenKey];
    
    //Session
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //Data Task
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                    if (error != nil)
                                                    {
                                                        NSLog(@"Error occured : %@",error);
                                                    }
                                                    if (responseObject == nil)
                                                    {
                                                        NSLog(@"Data dosen't exist");
                                                    }else
                                                    {
                                                        [[FIMyPageManager sharedManager] setReviewDatas:[NSMutableArray arrayWithArray:responseObject]];
                                                    }
                                                }];
    [dataTask resume];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

/*
 즐겨찾기 요청(POST, DELETE)
 */
+ (void)requestFavorRestaurantWithRestaurantPk:(PrimaryKey *)restaurantPk likePk:(PrimaryKey *)likePk
{
    NSString *URLString = [FIRequestObject requestURLString:RequestTypeFavor
                                               restaurantPk:restaurantPk
                                                   reviewPk:nil];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[[FILoginManager sharedManager] loginToken] forHTTPHeaderField:ParamNameLoginTokenKey];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    if (likePk != nil)
    {//URL String
        URLString = [NSString stringWithFormat:@"%@%@/", URLString, likePk];
        
        [manager DELETE:URLString
             parameters:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [FIRequestObject requestMyFavorRestaurantList];
                    [FIRequestObject requestRestaurantList];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                }];
    } else
    {
        [manager POST:URLString
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                  [FIRequestObject requestMyFavorRestaurantList];
                  [FIRequestObject requestRestaurantList];
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
              }];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

/*
 디테일 레스토랑(GET)
 */
+ (void)requestRestaurantDetailDataWithRestaurantPk:(PrimaryKey *)pk didReceiveUpdateDataBlock:(DidReceiveUpdateDataBlock)didReceiveUpdateDataBlock
{
    //URL String
    NSString *URLString = [FIRequestObject requestURLString:RequestTypeRestaurantList
                                               restaurantPk:nil
                                                   reviewPk:nil];
    URLString = [NSString stringWithFormat:@"%@%@/",URLString,pk];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    if ([FILoginManager isOnLogin])
    {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:[[FILoginManager sharedManager] loginToken] forHTTPHeaderField:ParamNameLoginTokenKey];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:URLString
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                 if (responseObject == nil)
                 {
                     NSLog(@"Data dosen't exist");
                 }else
                 {
                     [[FIDataManager sharedManager] setShopDetailData:responseObject];
                     didReceiveUpdateDataBlock();
                 }
             
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"%@", error);
         }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

@end
