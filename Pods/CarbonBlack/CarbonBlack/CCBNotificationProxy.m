//
//  CCBNotificationProxy.m
//  CarbonBlack
//
//  Created by Travis Fischer on 9/26/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCBNotificationProxy.h"
#import "CCBHTTPClient.h"
#import "CarbonBlack.h"

@implementation CCBNotificationProxy

/**
 * Shared singleton
 */
+ (id)sharedProxy {
    static dispatch_once_t pred;
    static CCBNotificationProxy *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[CCBNotificationProxy alloc] init];
    });
    return shared;
}

- (void)requestNotificationWithParameters:(NSDictionary *)params withSuccess:(void(^)(NSDictionary *response))success andFailure:(void(^)(NSError *error))failure {
    
    [[CCBHTTPClient sharedClient] POST:@"push_notifications.json"
                            parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                if (success) {
                                    success(responseObject);
                                }
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                if (failure) {
                                    failure(error);
                                }
                            }];
}

- (void)requestAPNSNotificationWithParameters:(NSDictionary *)params withSuccess:(void(^)(NSDictionary *response))success andFailure:(void(^)(NSError *error))failure {
    
    [[CCBHTTPClient sharedClient] POST:@"push_notifications/apns"
                            parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                if (success) {
                                    success(responseObject);
                                }
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                if (failure) {
                                    failure(error);
                                }
                            }];
}

- (void)requestGCMNotificationWithParameters:(NSDictionary *)params withSuccess:(void(^)(NSDictionary *response))success andFailure:(void(^)(NSError *error))failure {
    
    [[CCBHTTPClient sharedClient] POST:@"push_notifications/GCM"
                            parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                if (success) {
                                    success(responseObject);
                                }
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                if (failure) {
                                    failure(error);
                                }
                            }];
}


/**
 * Requests devices from the system
 * @param params Dictionary of parameters
 * @param success Success block that takes in an array of devices
 * @param failure Failure block that takes in an error object.
 */
- (void)requestDevicesWithParameters:(NSDictionary *)params success:(void(^)(NSDictionary *))success andFailure:(void(^)(NSError*))failure {
    
    [[CCBHTTPClient sharedClient] GET:@"devices.json" parameters:params
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  
                                  success(responseObject);
                                  
                              }
                              failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  failure(error);
                              }];
    
}



/**
 * Registers a device token for push
 * @param params The parameters for the request
 * @param success Block called on successful request. Takes a response dictionary
 * @param failure Block called on failed request. Takes an error for the failure.
 */
- (void)registerForNotificationsWithParameters:(NSDictionary *)params withSuccess:(void(^)(NSDictionary *response))success andFailure:(void(^)(NSError *error))failure {
    
    [[CCBHTTPClient sharedClient] PATCH:[NSString stringWithFormat:@"devices/%@", [CarbonBlack deviceId]]
                             parameters:params
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   if (success) {
                                       success(responseObject);
                                   }
                               }
                               failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   if (failure) {
                                       failure(error);
                                   }
                               }];
}
@end
