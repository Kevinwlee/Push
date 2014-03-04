//
//  CCBDevicesProxy.m
//  ContextHub
//
//  Created by Kevin Lee on 2/12/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "CCHDevicesProxy.h"

@implementation CCHDevicesProxy

+ (void)getDevicesWithSuccess:(void(^)(id responseObject))success
          failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {

    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    
    
    NSString *path = [NSString stringWithFormat:@"devices/"];

    [client GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}

+ (void)patchDevice:(NSDictionary *)device
             success:(void(^)(id responseObject))success
             failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {

    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"devices/%@", [device objectForKey:@"device_id"]];
    [client PATCH:path parameters:device success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
}

@end
