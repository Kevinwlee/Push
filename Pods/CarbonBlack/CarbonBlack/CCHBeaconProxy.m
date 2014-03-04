//
//  CCBBeaconProxy.m
//  ContextHub
//
//  Created by Kevin Lee on 11/7/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCHBeaconProxy.h"

@implementation CCHBeaconProxy
+ (void)getBeaconsWithSuccess:(void(^)(id responseObject))success
                        failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = @"beacons";
    
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    [client GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}

+ (void)createBeacon:(NSDictionary *)params success:(void(^)(id responseObject))success
             failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = @"beacons";
    
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    [client POST:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}

+ (void)updateBeacon:(NSDictionary *)params success:(void(^)(id responseObject))success
             failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *name =[NSString stringWithFormat:@"beacons/%@", [params valueForKeyPath:@"beacon.name"]];
    NSString *path = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    [client PATCH:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}

#pragma mark - cross app methods

+ (void)getBeaconsForAppId:(NSString *)appId success:(void(^)(id responseObject))success
                     failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:@"beacons?app_id=%@", appId];
    
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    
    [client GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}

@end
