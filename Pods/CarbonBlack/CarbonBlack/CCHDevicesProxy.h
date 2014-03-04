//
//  CCBDevicesProxy.h
//  ContextHub
//
//  Created by Kevin Lee on 2/12/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCHHTTPSessionClient.h"

/**
 Low level proxy for working with the ContextHub devices API.
 */
@interface CCHDevicesProxy : NSObject

/**
 Wraps the get devices endpoint
 @param success executed when the network request completes successfully.  The success block is passed the data that is received from the Context API.
 @param failure executed when the network request fails.  The session and error as passed to the failure block.
 @note the response object is an array of device dictionaries built from the api response.
 */
+ (void)getDevicesWithSuccess:(void(^)(id responseObject))success
                      failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 Wraps the patch devices endpoint.  The device is either created or updated with data from the device dictionary
 @param device a dictionary of the information that can be gathered for the device.
 @param success executed when the network request completes successfully.  The success block is passed the data that is received from the Context API.
 @param failure executed when the network request fails.  The session and error as passed to the failure block.
 @note the response object is a device dictionarie built from the api response.
 */
+ (void)patchDevice:(NSDictionary *)device
             success:(void(^)(id responseObject))success
             failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;


@end
