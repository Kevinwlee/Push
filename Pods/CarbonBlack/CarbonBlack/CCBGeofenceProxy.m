//
//  CCBGeofenceProxy.m
//  CarbonBlack
//
//  Created by Kevin Lee on 10/28/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCBGeofenceProxy.h"
#import "CCBHTTPClient.h"

@implementation CCBGeofenceProxy

+ (void)getGeofencesWithSuccess:(void(^)(id responseObject))success
                        failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = @"geo_fences";
    
    CCBHTTPClient *client = [CCBHTTPClient sharedClient];
    [client GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}

+ (void)getGeofencesNearLocation:(CLLocation *)location withSuccess:(void(^)(id responseObject))success
                         failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = @"geo_fences";
    NSString *latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    NSDictionary *params = @{@"lat":latitude, @"lng":longitude};
    CCBHTTPClient *client = [CCBHTTPClient sharedClient];
    [client GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}


+ (void)postGeofenceWithFenceInfo:(NSDictionary *)fenceInfo success:(void(^)(id responseObject))success
                        failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = @"geo_fences";
    NSDictionary *geofence = @{@"geo_fence": fenceInfo};
    
    CCBHTTPClient *client = [CCBHTTPClient sharedClient];
    [client POST:path parameters:geofence success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}

+ (void)patchGeofenceWithFenceInfo:(NSDictionary *)fenceInfo success:(void(^)(id responseObject))success
                            failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = @"geo_fences";
    
    CCBHTTPClient *client = [CCBHTTPClient sharedClient];
    [client PATCH:path parameters:fenceInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}

+ (void)deleteGeofenceWithId:(NSString *)fenceId success:(void(^)(id responseObject))success
                           failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:@"geo_fences/%@", fenceId];
    
    CCBHTTPClient *client = [CCBHTTPClient sharedClient];
    [client DELETE:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}

+ (void)getGeofencesForAppId:(NSString *)appId success:(void(^)(id responseObject))success
                     failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:@"geo_fences?app_id=%@", appId];
    
    CCBHTTPClient *client = [CCBHTTPClient sharedClient];
    
    [client GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}

@end
