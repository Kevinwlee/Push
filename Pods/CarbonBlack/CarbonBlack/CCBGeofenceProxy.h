//
//  CCBGeofenceProxy.h
//  CarbonBlack
//
//  Created by Kevin Lee on 10/28/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/** 
 Low level proxy for retreiving Geofences from the Carbon API.
 */
@interface CCBGeofenceProxy : NSObject

/** 
 Wraps a GET call to the Carbon geo_fence api.  This method queries the api for all geofences for the configured app id.
 @param success executed when the network request completes successfully.  The success is passed the JSON block that is received from the carbon API.
 @param failure executed when the network request fails.  The sessin and error as passed to the failure block.
 */
+ (void)getGeofencesWithSuccess:(void(^)(id responseObject))success
                        failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 Wraps a GET call to the Carbon geo_fence api.  This method queries the api for all geofences near the specifide location.
 @param location the location that will be used in the request.  
 @param success executed when the network request completes successfully.  The success is passed the JSON block that is received from the carbon API.
 @param failure executed when the network request fails.  The sessin and error as passed to the failure block.
 */
+ (void)getGeofencesNearLocation:(CLLocation *)location withSuccess:(void(^)(id responseObject))success
                         failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 Wraps a POST call to the Carbon geo_fence api.  This method creates a geofence in the configured app id.
 @param fenceInfo information used to create the geofence.  latitude, longitude, radius (meters), name.
 @param success executed when the network request completes successfully.  The success is passed the JSON block that is received from the carbon API.
 @param failure executed when the network request fails.  The sessin and error as passed to the failure block.
 */

+ (void)postGeofenceWithFenceInfo:(NSDictionary *)fenceInfo success:(void(^)(id responseObject))success
                          failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 Wraps a PATCH call to the Carbon geo_fence api.  This method updates the geofence.
 @param fenceInfo information used to create the geofence.  id, latitude, longitude, radius (meters), name.
 @param success executed when the network request completes successfully.  The success is passed the JSON block that is received from the carbon API.
 @param failure executed when the network request fails.  The sessin and error as passed to the failure block.
 */
+ (void)patchGeofenceWithFenceInfo:(NSDictionary *)fenceInfo success:(void(^)(id responseObject))success
                           failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 Wraps a DELETE call to the Carbon geo_fence api.  This method Deletes the geofence from the configured app id.
 @param fenceId id of the carbon geofence.
 @param success executed when the network request completes successfully.  The success is passed the JSON block that is received from the carbon API.
 @param failure executed when the network request fails.  The sessin and error as passed to the failure block.
 */
+ (void)deleteGeofenceWithId:(NSString *)fenceId success:(void(^)(id responseObject))success
                     failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 Wraps a GET call to the Carbon geo_fence api.  This method queries the api for all geofences for the given app id.
 @param appId of the application that you would like to query for geofences.
 @param success executed when the network request completes successfully.  The success is passed the JSON block that is received from the carbon API.
 @param failure executed when the network request fails.  The session and error are passed to the failure block.
 */

+ (void)getGeofencesForAppId:(NSString *)appId success:(void(^)(id responseObject))success
                     failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
