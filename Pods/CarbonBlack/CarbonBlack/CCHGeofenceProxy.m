//
//  CCBGeofenceProxy.m
//  ContextHub
//
//  Created by Kevin Lee on 10/28/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCHGeofenceProxy.h"
#import "CCHHTTPSessionClient.h"

@implementation CCHGeofenceProxy

+ (void)getGeofencesWithSuccess:(void(^)(id responseObject))success
                        failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = @"geo_fences";
    
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
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
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    [client GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}


+ (void)postGeofenceWithFenceInfo:(NSDictionary *)fenceInfo success:(void(^)(id responseObject))success
                        failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = @"geo_fences";
    NSDictionary *geofence = @{@"geo_fence": fenceInfo};
    
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    [client POST:path parameters:geofence success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}

+ (void)patchGeofenceWithFenceInfo:(NSDictionary *)fenceInfo success:(void(^)(id responseObject))success
                            failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = @"geo_fences";
    
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    [client PATCH:path parameters:fenceInfo success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}

+ (void)deleteGeofenceWithId:(NSString *)fenceId success:(void(^)(id responseObject))success
                           failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:@"geo_fences/%@", fenceId];
    
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    [client DELETE:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}

+ (void)getGeofencesForAppId:(NSString *)appId success:(void(^)(id responseObject))success
                     failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:@"geo_fences?app_id=%@", appId];
    
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    
    [client GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}

@end
