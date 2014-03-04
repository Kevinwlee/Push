//
//  CCBGeofenceService.m
//  ContextHub
//
//  Created by Kevin Lee on 10/29/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCHGeofenceService.h"

#define kLatitudeKey @"lat"
#define kLongitudeKey @"lng"
#define kRadiusKey @"radius"
#define kNameKey @"name"
#define kAppIdKey @"app_id"

@implementation CCHGeofenceService

+ (void)getGeofencesWithSuccess:(void(^)(NSArray *fences))success
                        failure:(void(^)(NSError *error))failure {
    
    [CCHGeofenceProxy getGeofencesWithSuccess:^(id responseObject) {
        
        NSMutableArray *fences = [NSMutableArray arrayWithCapacity:[responseObject count]];
        
        for (NSDictionary *fenceInfo in responseObject) {
            CLCircularRegion *fence = [CCHGeofenceService regionForFenceInfo:fenceInfo];
            [fences addObject:fence];
        }

        success(fences);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)getGeofencesNearLocation:(CLLocation *)location withSuccess:(void(^)(id responseObject))success
                         failure:(void(^)(NSError *error))failure {
    
    [CCHGeofenceProxy getGeofencesNearLocation:location withSuccess:^(id responseObject) {
        
        NSMutableArray *fences = [NSMutableArray arrayWithCapacity:[responseObject count]];
        
        for (NSDictionary *fenceInfo in responseObject) {
            CLCircularRegion *fence = [CCHGeofenceService regionForFenceInfo:fenceInfo];
            [fences addObject:fence];
        }
        
        success(fences);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getGeofencesNearByWithSuccess:(void(^)(NSArray *geofences))success
                              failure:(void(^)(NSError *error))failure {
    CLLocation *currentLocation = [ContextHub currentLocation];
    [CCHGeofenceService getGeofencesNearLocation:currentLocation
                                     withSuccess:success
                                         failure:failure];
}


+ (void)getGeofencesForAppId:(NSString *)appId
                     success:(void(^)(NSArray *fences))success
                     failure:(void(^)(NSError *error))failure {
    
    [CCHGeofenceProxy getGeofencesForAppId:appId success:^(id responseObject) {
        
        NSMutableArray *fences = [NSMutableArray arrayWithCapacity:[responseObject count]];
        
        for (NSDictionary *fenceInfo in responseObject) {
            CLCircularRegion *fence = [CCHGeofenceService regionForFenceInfo:fenceInfo];
            [fences addObject:fence];
        }
        
        success(fences);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)createGeofence:(CLCircularRegion *)region
            completion:(void(^)(NSDictionary *fenceInfo, NSError *error))completion {
    NSDictionary *fenceInfo = [self fenceInfoFromRegion:region];
    
    [CCHGeofenceProxy postGeofenceWithFenceInfo:fenceInfo success:^(id responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(fenceInfo, error);
    }];
}

+ (void)deleteGeofence:(NSDictionary *)fenceInfo
            completion:(void(^)(NSError *error))completion {

    NSString *fenceId = [fenceInfo objectForKey:@"geofence_id"];
    if (!fenceId) {
        [NSException raise:NSInvalidArgumentException format:@"the fenceInfo dictionary musth contain the geofence_id"];
    }
    [CCHGeofenceProxy deleteGeofenceWithId:fenceId success:^(id responseObject) {
        completion( nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(error);
    }];

}

+ (void)updateGeofence:(NSDictionary *)fenceInfo
            completion:(void(^)(NSDictionary *fenceInfo, NSError *error))completion {

    NSString *fenceId = [fenceInfo objectForKey:@"geofence_id"];
    if (!fenceId) {
        [NSException raise:NSInvalidArgumentException format:@"the fenceInfo dictionary musth contain the geofence_id"];
    }
    
    [CCHGeofenceProxy patchGeofenceWithFenceInfo:fenceInfo success:^(id responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(fenceInfo, error);
    }];
}

#pragma mark - Fence Helper Methods

+ (CLCircularRegion *)regionForFenceInfo:(NSDictionary *)fenceInfo {
    double latitude = [[fenceInfo objectForKey:kLatitudeKey] doubleValue];
    double longitude = [[fenceInfo objectForKey:kLongitudeKey] doubleValue];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    
    double radius = [[fenceInfo objectForKey:kRadiusKey] doubleValue];
    
    NSString *identifier = [fenceInfo objectForKey:kNameKey];
    
    CLCircularRegion *fence = [[CLCircularRegion alloc] initWithCenter:center radius:radius identifier:identifier];
    return fence;
}

+ (NSDictionary *)fenceInfoFromRegion:(CLCircularRegion *)region {
    NSNumber *latitude = [NSNumber numberWithDouble:region.center.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:region.center.longitude];
    NSNumber *radius = [NSNumber numberWithDouble:region.radius];
    NSString *name = region.identifier;
    NSDictionary *fenceInfo = @{kLatitudeKey:latitude, kLongitudeKey:longitude, kRadiusKey:radius, kNameKey:name};
    return fenceInfo;
}

@end
