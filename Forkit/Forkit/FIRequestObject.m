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
        [URLString appendString:[NSString stringWithFormat:@"%@/",restaurantPk]];
        
        switch (type)
        {//Review List
            case RequestTypeReviewList:
                [URLString appendString:URLNameReviews];
                break;
         //Review Deatail
            case RequestTypeReviewDetail:
                [URLString appendString:URLNameReviews];
                [URLString appendString:reviewPk];
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
 모든 음식점 리스트, 정렬, 검색 (GET)
 */
+ (void)requestRestaurantList:(NSDictionary *)paramDict didReceiveUpdateDataBlock:(DidReceiveUpdateDataBlock)didReceiveUpdateDataBlock
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
      parameters:paramDict
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             [[FIDataManager sharedManager]setShopDatas:[NSMutableArray arrayWithArray: [responseObject objectForKey:@"results"]]];
             didReceiveUpdateDataBlock();
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"%@", error);
         }];
    
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
}

/*
 특정 음식점에 따른 리뷰 등록 (POST)
 */
+ (void)requestUploadReviewListWithRestaurantPk:(PrimaryKey *)restaurantPk images:(NSArray *)images contents:(NSString *)contents score:(NSInteger)score
{
    /*
    //create URL
    NSString *requsetURL = [FIRequestObject requestURLString:RequestTypeReviewList
                                                restaurantPk:restaurantPk
                                                    reviewPk:nil];
    
    
    //create bodyParms
    NSMutableDictionary *bodyParms = [NSMutableDictionary dictionary];
    [bodyParms setObject:contents forKey:JSONReviewContentKey];
    [bodyParms setObject:contents forKey:@"title"];
    [bodyParms setObject:image forKey:JSONCommonSmallImageURLKey];
    [bodyParms setObject:[NSNumber numberWithInteger:score] forKey:JSONReviewScoreKey];
    
    //create construct body block
    id constructBodyBlock = ^(id<AFMultipartFormData>  _Nonnull formData)
    {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.1)
                                    name:JSONCommonThumbnailImageURLKey
                                fileName:@"image.jpeg"
                                mimeType:@"image/jpeg"];
    };
     
    [bodyParms setObject:contents forKey:JSONReviewContentKey];
    [bodyParms setObject:[NSString stringWithFormat:@"%ld", score] forKey:JSONReviewScoreKey];
    
    //create Request
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:requsetURL
                                                                                             parameters:bodyParms constructingBodyWithBlock:constructBodyBlock error:nil];
    
    [request setValue:[[FILoginManager sharedManager] loginToken] forHTTPHeaderField:ParamNameLoginTokenKey];
    
    //create URLSession
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    //create UploadTask
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request
                                                               fromData:nil
                                                               progress:nil
                                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                          
                                                          NSLog(@"response: %@", response);
                                                          if (error != nil)
                                                          {
                                                              NSLog(@"Error occured : %@", error);
                                                          }
                                                          if (responseObject == nil)
                                                          {
                                                              NSLog(@"Data dosen't exist");
                                                          } else
                                                          {
                                                              NSLog(@"%@",responseObject);
                                                          }
                                                      }];

    
    [uploadTask resume];
     */
}

/*
 특정 음식점에 따른 특정 리뷰 (DELETE)
 */
+ (void)requestDeleteReviewWithRestaurantPk:(PrimaryKey *)restaurantPk reviewPk:(PrimaryKey *)reviewPk
{
    
    //URL String
    NSString *URLString = [FIRequestObject requestURLString:RequestTypeReviewDetail
                                               restaurantPk:restaurantPk
                                                   reviewPk:reviewPk];
    
    //Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    request.HTTPMethod = @"DELETE";
    [request setValue:[[FILoginManager sharedManager] loginToken] forHTTPHeaderField:ParamNameLoginTokenKey];
    
    //Session
    NSURLSession *session = [NSURLSession sharedSession];
    
    //Data Task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    NSLog(@"%@",response);
                                                }];
    [dataTask resume];
     
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
}

+ (void)requestMyFavorRestaurantList:(DidReceiveUpdateDataBlock)didReceiveUpdateDataBlock
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
                                                        [[FIDataManager sharedManager]setShopDatas:[NSMutableArray arrayWithArray: responseObject]];
                                                        didReceiveUpdateDataBlock();
                                                    }
                                                }];
    [dataTask resume];
}

+ (void)requestMyRegisterReview:(DidReceiveUpdateDataBlock)didReceiveUpdateDataBlock
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
                                                        [[FIReviewDataManager sharedManager] setReviewDatas:[NSMutableArray arrayWithArray:responseObject]];
                                                        didReceiveUpdateDataBlock();
                                                    }
                                                }];
    [dataTask resume];
}

+ (void)requestFavorRestaurantWithRestaurantPk:(PrimaryKey *)RestaurantPk likePk:(PrimaryKey *)likePk
{
    NSString *URLString = [FIRequestObject requestURLString:RequestTypeFavor
                                               restaurantPk:RestaurantPk
                                                   reviewPk:nil];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[[FILoginManager sharedManager] loginToken] forHTTPHeaderField:ParamNameLoginTokenKey];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    if (likePk != nil)
    {//URL String
        URLString = [NSString stringWithFormat:@"%@%@", URLString, likePk];
        
        //Request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
        request.HTTPMethod = @"DELETE";
        [request setValue:[[FILoginManager sharedManager] loginToken] forHTTPHeaderField:ParamNameLoginTokenKey];
        
        //Session
        NSURLSession *session = [NSURLSession sharedSession];
        
        //Data Task
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                        NSLog(@"%@",response);
                                                    }];
        [dataTask resume];
        
        
        /*
        [manager DELETE:URLString
             parameters:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSLog(@"responseObject : %@",responseObject);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                }];
         */
    } else
    {
        [manager POST:URLString
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
              }];
    }
}

@end
