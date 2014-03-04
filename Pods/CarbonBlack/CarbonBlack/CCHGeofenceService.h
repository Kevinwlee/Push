//
//  CCBGeofenceService.h
//  ContextHub
//
//  Created by Kevin Lee on 10/29/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "CCHGeofenceProxy.h"
#import "ContextHub.h"

/** 
 Used to get CLCircularRegions (geofences) from the ContextHub api.
 */
@interface CCHGeofenceService : CLCircularRegion

/** 
 get geofences from ContextHub api
 @param success executed when the network request completes without errors.  The success param is passed an array of CLCircularRegions.
 @param failure executed when the network request fails.  The session and error are passed to the failure block.
 */
+ (void)getGeofencesWithSuccess:(void(^)(NSArray *fences))success
                        failure:(void(^)(NSError *error))failure;

/**
 get geofences from ContextHub api
 @param location to be used to find the nearest geofences
 @param success executed when the network request completes without errors.  The success param is passed an array of CLCircularRegions.
 @param failure executed when the network request fails.  The session and error are passed to the failure block.
 */

+ (void)getGeofencesNearLocation:(CLLocation *)location withSuccess:(void(^)(id responseObject))success
                         failure:(void(^)(NSError *error))failure;


/**
 get geofences from ContextHub api that are near the current location.
 @param success executed when the network request completes without errors.  The success param is passed an array of CLCircularRegions.
 @param failure executed when the network request fails.  The session and error are passed to the failure block.
 */
+ (void)getGeofencesNearByWithSuccess:(void(^)(NSArray *geofences))success
                              failure:(void(^)(NSError *error))failure;

/** 
 @param appId the application id for the app that you want to query geofences.  
 @warning The appId must be an app id that is associated with your client id.
 @param success executed when the network request completes without errors.  The success param is passed an array of CLCircularRegions.
 @param failure executed when the network request fails.  The session and error are passed to the failure block.
 */
+ (void)getGeofencesForAppId:(NSString *)appId
                     success:(void(^)(NSArray *fences))success
                     failure:(void(^)(NSError *error))failure;

/**
used to create geofence on the ContextHub server.
@param region geofence region
@param completion executed when the network request completes. If successful, a fence info dictionary will be returned.  If an error occurs, the NSError will be returned.
*/
+ (void)createGeofence:(CLCircularRegion *)region
            completion:(void(^)(NSDictionary *fenceInfo, NSError *error))completion;

/**
 used to delete a geofence on the ContextHub server.
 @param fenceInfo is a dictionary that must contain the fence id of the geofence that is to be deleted.
 @param completion executed when the network request completes. an error will be returned if there was a problem deleting the geofence.
 */
+ (void)deleteGeofence:(NSDictionary *)fenceInfo
            completion:(void(^)(NSError *error))completion;

/**
 used to update a geofence on the ContextHub server.
 @param fenceInfo is a dictionary that must contain the fence id of the geofence that is to updated.
 @param completion executed when the network request completes. an error will be returned if there was a problem deleting the geofence.
 */
+ (void)updateGeofence:(NSDictionary *)fenceInfo
            completion:(void(^)(NSDictionary *fenceInfo, NSError *error))completion;


@end
