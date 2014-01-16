//
//  CCBNotificationProxy.h
//  CarbonBlack
//
//  Created by Travis Fischer on 9/26/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 low level proxy that wraps the carbon push api.
 */
@interface CCBNotificationProxy : NSObject

/**
 * Shared singleton
 */
+ (id)sharedProxy;

/**
 * Request a notification to be sent from Carbon
 * @param params Dictionary of parameters for request
 * @param success Block called on successful request. Takes a response dictionary
 * @param failure Block called on failed request. Takes an error for the failure.
 */
- (void)requestNotificationWithParameters:(NSDictionary *)params withSuccess:(void(^)(NSDictionary *response))success andFailure:(void(^)(NSError *error))failure;

/**
 * Request an APNS notification to be sent from Carbon
 * @param params Dictionary of parameters for request
 * @param success Block called on successful request. Takes a response dictionary
 * @param failure Block called on failed request. Takes an error for the failure.
 */
- (void)requestAPNSNotificationWithParameters:(NSDictionary *)params withSuccess:(void(^)(NSDictionary *response))success andFailure:(void(^)(NSError *error))failure;

/**
 * Request a GCM notification to be sent from Carbon
 * @param params Dictionary of parameters for request
 * @param success Block called on successful request. Takes a response dictionary
 * @param failure Block called on failed request. Takes an error for the failure.
 */
- (void)requestGCMNotificationWithParameters:(NSDictionary *)params withSuccess:(void(^)(NSDictionary *response))success andFailure:(void(^)(NSError *error))failure;


/**
 * Requests devices from the system
 * @param params Dictionary of parameters
 * @param success Success block that takes in an array of devices
 * @param failure Failure block that takes in an error object.
 */
- (void)requestDevicesWithParameters:(NSDictionary *)params success:(void(^)(NSDictionary *))success andFailure:(void(^)(NSError*))failure;

/**
 * Registers a device token for push
 * @param params The parameters for the request
 * @param success Block called on successful request. Takes a response dictionary
 * @param failure Block called on failed request. Takes an error for the failure.
 */
- (void)registerForNotificationsWithParameters:(NSDictionary *)params withSuccess:(void(^)(NSDictionary *response))success andFailure:(void(^)(NSError *error))failure;


@end
