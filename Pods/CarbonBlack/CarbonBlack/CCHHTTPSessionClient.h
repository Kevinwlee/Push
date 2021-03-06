//
//  CCBHTTPClient.h
//  ContextHub
//
//  Created by Kevin Lee on 9/23/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
/**
 The base URL for the ContextHub API
 */
FOUNDATION_EXPORT NSString *const ContextHubBaseURL;

/**
 The client should be used for all HTTP communication with the ContextHub API.
 */
@interface CCHHTTPSessionClient : AFHTTPSessionManager

/**
 @returns an singleton incstance of the network client.  This client should be use for all communication with the ContextHub API.
 */
+ (CCHHTTPSessionClient *)sharedClient;

/**
 This method is used to create a multipart form update
 @returns sessionDataTask
 @param URLString path to vault object
 @param parameters vault object
 @param block multi-part formj block
 @param success block
 @param failure block
  */

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
    constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
