//
//  FILoginManager.m
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "FILoginManager.h"
#import "KeychainItemWrapper.h"

#pragma mark - User info key
//user info key
static NSString * const UserInfoKeyLoginState = @"UserInfoKeyLoginState";
//user info value
static NSString * const UserInfoValueLogin = @"login";
//key chain identifier
static NSString *const  KeyChainIdentifierloginToken = @"KeyChainIdentifierloginToken";

@interface FILoginManager ()

@property KeychainItemWrapper *wrapper;

@end

@implementation FILoginManager

#pragma mark - singleton
+ (instancetype)sharedManager
{
    static FILoginManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:KeyChainIdentifierloginToken
                                                                    accessGroup:nil];
    });
    
    return sharedManager;
}

#pragma mark - login token
- (void)setLoginToken:(NSString *)token
{
    if ([[_wrapper objectForKey:(__bridge id)(kSecAttrAccount)] isEqualToString:@""] ||
        [_wrapper objectForKey:(__bridge id)(kSecAttrAccount)] == nil)
    {
        [_wrapper setObject:token forKey:(__bridge id)(kSecAttrAccount)];
    }
}

- (NSString *)loginToken
{
    return [_wrapper objectForKey:(__bridge id)(kSecAttrAccount)];
}

- (void)removeLoginToken
{
    [_wrapper resetKeychainItem];
}

#pragma mark - login state
+ (void)setLoginState
{
    [[NSUserDefaults standardUserDefaults] setObject:UserInfoValueLogin
                                              forKey:UserInfoKeyLoginState];
}

+ (void)removeLoginState
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserInfoKeyLoginState];
}

+ (BOOL)isOnLogin
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLoginState] isEqualToString:UserInfoValueLogin])
    {
        return YES;
    } else
    {
        return NO;
    }
}
@end
