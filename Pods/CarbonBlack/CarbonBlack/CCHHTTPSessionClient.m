//
//  CBHTTPClient.m
//  ContextHub
//
//  Created by Kevin Lee on 9/23/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCHHTTPSessionClient.h"
#import "ContextHub.h"

NSString *const ContextHubBaseURL = @"http://carbon-staging.herokuapp.com/api/";

//NSString *const Carbon

@implementation CCHHTTPSessionClient

+ (CCHHTTPSessionClient *)sharedClient {
    static CCHHTTPSessionClient *__sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSMutableDictionary *headers = [NSMutableDictionary dictionary];
        
        if (![ContextHub deviceId]) {
            [NSException raise:NSInvalidArgumentException format:@"Device ID has not been set."];
        }
        
        [headers setObject:[ContextHub deviceId] forKey:@"CARBON_DEVICE_ID"];

        NSString *authToken = [NSString stringWithFormat:@"Token token=%@", [ContextHub applicationId]];
        [headers setObject:authToken forKey:@"Authorization"];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        [headers setObject:@"application/json" forKey:@"Content-Type"];
        [headers setObject:@"application/json" forKey:@"Accept"];

#ifdef DEBUG
        [headers setObject:@"debug build" forKey:@"CARBON_DEBUG"];
#else
        
#endif

        [config setHTTPAdditionalHeaders:headers];
        
        __sharedClient = [[CCHHTTPSessionClient alloc] initWithBaseURL:[NSURL URLWithString:ContextHubBaseURL] sessionConfiguration:config];
    });
    
    return __sharedClient;
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
    constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block];
    
    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    
    [task resume];
    
    return task;
}

@end
