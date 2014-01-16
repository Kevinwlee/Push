//
//  CCBBeaconProxy.m
//  CarbonBlack
//
//  Created by Kevin Lee on 11/7/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCBBeaconProxy.h"

@implementation CCBBeaconProxy
+ (void)getBeaconsWithSuccess:(void(^)(id responseObject))success
                        failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = @"beacons";
    
    CCBHTTPClient *client = [CCBHTTPClient sharedClient];
    [client GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}

+ (void)getBeaconsForAppId:(NSString *)appId success:(void(^)(id responseObject))success
                     failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:@"beacons?app_id=%@", appId];
    
    CCBHTTPClient *client = [CCBHTTPClient sharedClient];
    
    [client GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}
@end
