//
//  FIRequestObject.m
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "FIRequestObject.h"
#import <AFNetworking.h>

//Request Type
typedef NS_ENUM(NSInteger, RequestType)
{
    RequestTypeRestaurantList,
    RequestTypeReviewList,
    RequestTypeReviewDetail,
    RequestTypeMenuList
};

//URL Name
static NSString *const URLNameRestaurants = @"restaurants/";
static NSString *const URLNameReviews = @"reviews/";
static NSString *const URLNameMenus = @"menus/";

//Base URL String
static NSString *const BaseURLString = @"http://mangoplates.com/";
static NSString *const BasePathString = @"api/v1/";

@implementation FIRequestObject


//create URLString
+ (NSString *)requestURLString:(RequestType)type restaurantPk:(PrimaryKey *)restaurantPk reviewPk:(PrimaryKey *)reviewPk
{
    NSMutableString *URLString = [BaseURLString mutableCopy];
    [URLString appendString:BasePathString];
    [URLString appendString:URLNameRestaurants];
    
    if (type == RequestTypeRestaurantList)
    {//Restaurant List
        return URLString;
    } else
    {
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
                NSLog(@"%@",URLString);
                break;
         //Menu List
            case RequestTypeMenuList:
                [URLString appendString:URLNameMenus];
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
    NSString *URLString = [FIRequestObject requestURLString:RequestTypeRestaurantList restaurantPk:nil reviewPk:nil];
    
    //Request
    NSMutableURLRequest *requset = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    requset.HTTPMethod = @"GET";
    
    //Session
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //Task
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:requset
                                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                    NSLog(@"%@",response);
                                                    if (error != nil)
                                                    {
                                                        NSLog(@"Error occured : %@",error);
                                                    }
                                                    if (responseObject == nil)
                                                    {
                                                        NSLog(@"Data dosen't exist");
                                                    }else
                                                    {
                                                        //responseObject를 restaurant list manager에 저장
                                                        NSLog(@"%@",responseObject);
                                                    }
                                                }];
    
    //Resume
    [dataTask resume];
}

/*
 특정 음식점에 따른 메뉴 리스트 (GET)
 */
+ (void)requestMenuListWithRestaurantPk:(PrimaryKey *)restaurantPk
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
                                                    NSLog(@"%@",response);
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
                                                        NSLog(@"%@",responseObject);
                                                    }
                                                }];
    
    [dataTask resume];
}


/*
 특정 음식점에 따른 리뷰 리스트 (GET)
 */
+ (void)requestReviewListWithRestaurantPk:(PrimaryKey *)restaurantPk
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
                                                    NSLog(@"%@",response);
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
                                                        NSLog(@"%@",responseObject);
                                                    }
                                                }];
    
    [dataTask resume];
}

/*
 특정 음식점에 따른 리뷰 등록 (POST)
 */
+ (void)requestUploadReviewListWithRestaurantPk:(PrimaryKey *)restaurantPk image:(UIImage *)image contents:(NSString *)contents score:(NSInteger)score
{
    //create URL
    NSString *requsetURL = [FIRequestObject requestURLString:RequestTypeReviewList
                                                restaurantPk:restaurantPk
                                                    reviewPk:nil];
    
    //create bodyParms
    NSMutableDictionary *bodyParms = [NSMutableDictionary dictionary];
    
    /*
    [bodyParms setObject:title
                  forKey:JSONCommonThumbnailImageURL];
    if (imageId != nil)
    {
        [bodyParms setObject:imageId forKey:@"id"];
    }
    */
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
    
    //Session
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //Data Task
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                    NSLog(@"%@",response);
                                                    if (error != nil)
                                                    {
                                                        NSLog(@"Error occured : %@",error);
                                                    }
                                                }];
    
    [dataTask resume];
}

@end
