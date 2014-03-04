//
//  CCBBeaconProxy.h
//  ContextHub
//
//  Created by Kevin Lee on 11/7/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCHHTTPSessionClient.h"

/**
 The CCBBeaconProxy is a thin wrapper around the ContextHub API that is used to retreive iBeacons.

    /api​/beacons
 */

@interface CCHBeaconProxy : NSObject

/**
 Wraps a GET request to the ContextHub beacon api.  This method queries the api for all beacon for the configured app id.
 @param success the block is executed when the network request completes successfully.  The responseObject passed to the block contains an NSArray of NSDictionaries that represnt iBeacons.
 @param failure executed when the network request fails.  The session and error as passed to the failure block.
 */
+ (void)getBeaconsWithSuccess:(void(^)(id responseObject))success
                        failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;


/**
 Wraps a POST request to the ContextHub beacon api.
 @note the name of the beacon must be unique in your application.
 @param params the beacon info name, udid, major, minor.
 @param success executed when the network request completes successfully.  The responseObject passed to the block contains an NSArray of NSDictionaries that represnt iBeacons.
 @param failure executed when the network request fails.  The sessin and error as passed to the failure block.
 */
+ (void)createBeacon:(NSDictionary *)params success:(void(^)(id responseObject))success
             failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;


/**
 Wraps a PATCH call to the ContextHub beacon api.
 @note the name of the beacon must be unique in your application.
 @param params the beacon info name, udid, major, minor.
 @param success executed when the network request completes successfully.  The success is passed the JSON block that is received from the ContextHub API.
 @param failure executed when the network request fails.  The sessin and error as passed to the failure block.
 */
+ (void)updateBeacon:(NSDictionary *)params success:(void(^)(id responseObject))success
             failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;


/**
 Wraps a GET call to the ContextHub beacon api.  This method queries the api for all beacon for the given app id.
 @param appId of the application that you would like to query for beacon.
 @param success executed when the network request completes successfully.  The success is passed the JSON block that is received from the ContextHub API.
 @param failure executed when the network request fails.  The session and error are passed to the failure block.
 */

+ (void)getBeaconsForAppId:(NSString *)appId success:(void(^)(id responseObject))success
                     failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;


@end
