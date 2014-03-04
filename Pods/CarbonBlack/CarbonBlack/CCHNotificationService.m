//
//  CCBNotificationService.m
//  ContextHub
//
//  Created by Travis Fischer on 9/26/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCHNotificationService.h"
#import "CCHNotificationProxy.h"

static NSString * CCBSanitizedDeviceTokenStringWithDeviceToken(id deviceToken) {
    return [[[[deviceToken description] lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@implementation CCHNotificationService

+ (id)sharedService {
    static dispatch_once_t pred;
    static CCHNotificationService *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[CCHNotificationService alloc] init];
    });
    return shared;
}

- (void)registerDeviceToken:(id)token withCompletion:(void(^)(NSError *error))completion {
    [self registerDeviceToken:token withAlias:nil andTags:nil withCompletion:completion];
}

- (void)registerDeviceToken:(id)token withAlias:(NSString *)alias withCompletion:(void(^)(NSError *error))completion {
    [self registerDeviceToken:token withAlias:alias andTags:nil withCompletion:completion];
}

- (void)registerDeviceToken:(id)token withAlias:(NSString *)alias andTags:(NSArray *)tags withCompletion:(void(^)(NSError *error))completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:CCBSanitizedDeviceTokenStringWithDeviceToken(token) forKey:@"push_token"];
    
    if (alias) {
        [params setObject:alias forKey:@"alias"];
    }
    
    if (tags) {
        [params setObject:tags forKey:@"tags"];
    }
    
    [[CCHNotificationProxy sharedProxy] registerForNotificationsWithParameters:params
                                                                   withSuccess:^(NSDictionary *response) {
                                                                       if (completion) {
                                                                           completion(nil);
                                                                       }
                                                                   }
                                                                    andFailure:^(NSError *error) {
                                                                        if (completion) {
                                                                            completion(error);
                                                                        }
                                                                    }];
}

- (void)requestDevicesForNotificationWithCompletion:(void(^)(NSArray *devices, NSError * error))completion {
    
    [[CCHNotificationProxy sharedProxy] requestDevicesWithParameters:nil
                                                             success:^(NSDictionary *response) {
                                                                 NSArray *devices = response[@"devices"];
                                                                 NSMutableArray *pushIds = [NSMutableArray arrayWithCapacity:[devices count]];
                                                                 for (NSDictionary *deviceDict in devices) {
                                                                     [pushIds addObject:deviceDict[@"push_token"]];
                                                                 }
                                                                 if (completion) {
                                                                     completion(pushIds, nil);
                                                                 }
                                                             }
                                                          andFailure:^(NSError *error) {
                                                              if (completion) {
                                                                  completion(nil, error);
                                                              }
                                                          }];
}


#pragma mark - simple notifications

- (void)sendNotificationToDevices:(NSArray *)devices withMessage:(NSString *)message userInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *error))completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:devices forKey:@"device_push_tokens"];
    [params setObject:message forKey:@"message"];
    
    [self requestNotificationWithParams:params completion:completion];
}


- (void)sendNotificationToAliases:(NSArray *)aliases withMessage:(NSString *)message userInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *error))completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:aliases forKey:@"alias"];
    [params setObject:message forKey:@"message"];
    
    [self requestNotificationWithParams:params completion:completion];
}


- (void)sendNotificationToTags:(NSArray *)tags withMessage:(NSString *)message userInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *error))completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:tags forKey:@"tags"];
    [params setObject:message forKey:@"message"];
    
    [self requestNotificationWithParams:params completion:completion];
}


- (void)requestNotificationWithParams:(NSDictionary *)params completion:(void (^)(NSError *error))completion {
    [[CCHNotificationProxy sharedProxy] requestNotificationWithParameters:params withSuccess:^(NSDictionary *response) {
        if (completion) {
            completion(nil);
        }
    } andFailure:^(NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}


#pragma mark - APNS

- (void)sendAPNSNotificationToDevices:(NSArray *)devices userInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *error))completion {
    NSMutableDictionary *params = [self parametersWithAPNSUserInfo:userInfo];
    [params setObject:devices forKey:@"device_push_tokens"];
    
    [self requestAPNSNotificationWithParams:params completion:completion];
}

- (void)sendAPNSNotificationToAliases:(NSArray *)aliases userInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *error))completion {
    NSMutableDictionary *params = [self parametersWithAPNSUserInfo:userInfo];
    [params setObject:aliases forKey:@"alias"];

    [self requestAPNSNotificationWithParams:params completion:completion];
}

- (void)sendAPNSNotificationToTags:(NSArray *)tags userInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *error))completion {
    NSMutableDictionary *params = [self parametersWithAPNSUserInfo:userInfo];
    [params setObject:tags forKey:@"tags"];
    
    [self requestAPNSNotificationWithParams:params completion:completion];
}

- (NSMutableDictionary *)parametersWithAPNSUserInfo:(NSDictionary *)userInfo {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *mutableInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    
    if ([userInfo objectForKey:@"sound"]) {
        [params setObject:[userInfo objectForKey:@"sound"] forKey:@"sound"];
        [mutableInfo removeObjectForKey:@"sound"];
    }
    
    if ([userInfo objectForKey:@"alert"]) {
        [params setObject:[userInfo objectForKey:@"alert"] forKey:@"alert"];
        [mutableInfo removeObjectForKey:@"alert"];
    }
    
    if ([userInfo objectForKey:@"content-available"]) {
        [params setObject:[userInfo objectForKey:@"content-available"] forKey:@"content_available"];
        [mutableInfo removeObjectForKey:@"content-available"];
    }
    
    if ([userInfo objectForKey:@"badge"]) {
        [params setObject:[userInfo objectForKey:@"badge"] forKey:@"badge"];
        [mutableInfo removeObjectForKey:@"badge"];
    }
    
    if (mutableInfo) {
        if (mutableInfo.count > 0) {
            [params setObject:mutableInfo forKey:@"data"];
        }
    }
    
    return params;
}

- (void)requestAPNSNotificationWithParams:(NSDictionary *)params completion:(void (^)(NSError *error))completion {
    [[CCHNotificationProxy sharedProxy] requestAPNSNotificationWithParameters:params withSuccess:^(NSDictionary *response) {
        if (completion) {
            completion(nil);
        }
    } andFailure:^(NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}
@end
