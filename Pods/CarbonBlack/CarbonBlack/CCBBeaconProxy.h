//
//  CCBBeaconProxy.h
//  CarbonBlack
//
//  Created by Kevin Lee on 11/7/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCBHTTPClient.h"

/**
 Low level proxy for retreiving iBeacons from the Carbon API.
 */

@interface CCBBeaconProxy : NSObject

/**
 Wraps a GET call to the Carbon beacon api.  This method queries the api for all beacon for the configured app id.
 @param success executed when the network request completes successfully.  The success is passed the JSON block that is received from the carbon API.
 @param failure executed when the network request fails.  The sessin and error as passed to the failure block.
 */
+ (void)getBeaconsWithSuccess:(void(^)(id responseObject))success
                        failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;


/**
 Wraps a GET call to the Carbon beacon api.  This method queries the api for all beacon for the given app id.
 @param appId of the application that you would like to query for beacon.
 @param success executed when the network request completes successfully.  The success is passed the JSON block that is received from the carbon API.
 @param failure executed when the network request fails.  The session and error are passed to the failure block.
 */

+ (void)getBeaconsForAppId:(NSString *)appId success:(void(^)(id responseObject))success
                     failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;


@end
