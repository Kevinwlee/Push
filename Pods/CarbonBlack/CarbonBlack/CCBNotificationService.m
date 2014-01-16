//
//  CCBNotificationService.m
//  CarbonBlack
//
//  Created by Travis Fischer on 9/26/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCBNotificationService.h"
#import "CCBNotificationProxy.h"

static NSString * CCBSanitizedDeviceTokenStringWithDeviceToken(id deviceToken) {
    return [[[[deviceToken description] lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@implementation CCBNotificationService

/**
 * Singleton instance of notification service
 */
+ (id)sharedService {
    static dispatch_once_t pred;
    static CCBNotificationService *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[CCBNotificationService alloc] init];
    });
    return shared;
}

/**
 * Register a device for push notification. Use the same method to update existing registrations as well.
 * @param token The device token
 * @param completion Completion block for registration. Returns nil if succeeded otherwise includes an error object.
 */
- (void)registerDeviceToken:(id)token withCompletion:(void(^)(NSError *error))completion {
    
    [self registerDeviceToken:token withAlias:nil andTags:nil withCompletion:completion];
}

/**
 * Register a device for push notification.
 * @param token The device token
 * @param alias A string alias to associate with the device token.
 * @param completion Completion block for registration. Returns nil if succeeded otherwise includes an error object.
 */
- (void)registerDeviceToken:(id)token withAlias:(NSString *)alias withCompletion:(void(^)(NSError *error))completion {
    
    [self registerDeviceToken:token withAlias:alias andTags:nil withCompletion:completion];
    
}

/**
 * Register a device for push notification.
 * @param token The device token
 * @param alias A string alias to associate with the device token.
 * @param tags An array of tags to associate with the token
 * @param completion Completion block for registration. Returns nil if succeeded otherwise includes an error object.
 */
- (void)registerDeviceToken:(id)token withAlias:(NSString *)alias andTags:(NSArray *)tags withCompletion:(void(^)(NSError *error))completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:CCBSanitizedDeviceTokenStringWithDeviceToken(token) forKey:@"push_token"];
    
    if (alias) {
        [params setObject:alias forKey:@"alias"];
    }
    
    if (tags) {
        [params setObject:tags forKey:@"tags"];
    }
    
    [[CCBNotificationProxy sharedProxy] registerForNotificationsWithParameters:params
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

/**
 * Send a notification to multiple devices
 * @param device The devices to notify
 * @param message The message to be sent
 * @param userInfo Other data to be sent in the notification
 * @param completion Completion block. Not sure what this should take yet.
 */
- (void)sendNotificationToDevices:(NSArray *)devices withMessage:(NSString *)message userInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *error))completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:devices forKey:@"device_push_tokens"];
    [params setObject:message forKey:@"message"];
    
    [[CCBNotificationProxy sharedProxy] requestNotificationWithParameters:params withSuccess:^(NSDictionary *response) {
        if (completion) {
            completion(nil);
        }
    } andFailure:^(NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)sendNotificationToAppId:(NSString *)appId devices:(NSArray *)devices withMessage:(NSString *)message userInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *error))completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appId forKey:@"app_id"];
    [params setObject:devices forKey:@"device_push_tokens"];
    [params setObject:message forKey:@"message"];
    
    [[CCBNotificationProxy sharedProxy] requestNotificationWithParameters:params withSuccess:^(NSDictionary *response) {
        if (completion) {
            completion(nil);
        }
    } andFailure:^(NSError *error) {
        if (completion) {
            completion(error);
        }
    }];

}

/**
 * Send a notification to multiple registered aliases
 * @param device The aliases to notify
 * @param message The message to be sent
 * @param userInfo Other data to be sent in the notification
 * @param completion Completion block. Not sure what this should take yet.
 */
- (void)sendNotificationToAliases:(NSArray *)aliases withMessage:(NSString *)message userInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *error))completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:aliases forKey:@"alias"];
    [params setObject:message forKey:@"message"];
    
    [[CCBNotificationProxy sharedProxy] requestNotificationWithParameters:params withSuccess:^(NSDictionary *response) {
        if (completion) {
            completion(nil);
        }
    } andFailure:^(NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)sendAPNSNotificationToAliases:(NSArray *)aliases userInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *error))completion {
    

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:aliases forKey:@"alias"];
    
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
        [params setObject:[userInfo objectForKey:@"content-available"] forKey:@"content-available"];
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
    
    [[CCBNotificationProxy sharedProxy] requestAPNSNotificationWithParameters:params withSuccess:^(NSDictionary *response) {
        if (completion) {
            completion(nil);
        }
    } andFailure:^(NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}


- (void)sendNotificationToAppId:(NSString *)appId aliases:(NSArray *)aliases withMessage:(NSString *)message userInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *error))completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appId forKey:@"app_id"];
    [params setObject:aliases forKey:@"alias"];
    [params setObject:message forKey:@"message"];
    
    [[CCBNotificationProxy sharedProxy] requestNotificationWithParameters:params withSuccess:^(NSDictionary *response) {
        if (completion) {
            completion(nil);
        }
    } andFailure:^(NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

/**
 * Request the devices registered to receive push notifications
 * @param completion Completion block that takes a list of devices and an error. If the request succeeded, the error object will be nil.
 */
- (void)requestDevicesForNotificationWithCompletion:(void(^)(NSArray *devices, NSError * error))completion {
    
    [[CCBNotificationProxy sharedProxy] requestDevicesWithParameters:nil
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

/**
 * Send a notification to multiple tag sets
 * @param tags The tags to notify
 * @param message The message to be sent
 * @param userInfo Other data to be sent in the notification
 * @param completion Completion block. Not sure what this should take yet.
 */
- (void)sendNotificationToTags:(NSArray *)tags withMessage:(NSString *)message userInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *error))completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // add devices to param
    
    [params setObject:tags forKey:@"tags"];
    
    [params setObject:message forKey:@"message"];
    
    [[CCBNotificationProxy sharedProxy] requestNotificationWithParameters:params withSuccess:^(NSDictionary *response) {
        if (completion) {
            completion(nil);
        }
    } andFailure:^(NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
    
}

- (void)sendNotificationToAppId:(NSString *)appId tags:(NSArray *)tags withMessage:(NSString *)message userInfo:(NSDictionary *)userInfo withCompletion:(void (^)(NSError *error))completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appId forKey:@"app_id"];

    [params setObject:tags forKey:@"tags"];

    [params setObject:message forKey:@"message"];
    
    [[CCBNotificationProxy sharedProxy] requestNotificationWithParameters:params withSuccess:^(NSDictionary *response) {
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
