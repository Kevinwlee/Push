//
//  CCBBeaconService.h
//  CarbonBlack
//
//  Created by Kevin Lee on 11/7/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CCBBeaconProxy.h"
/**
 The beacon servers is used to retrive iBeacons that have been created on the Carbon server.
 */
@interface CCBBeaconService : NSObject
/**
 
 @param success executed when the network request completes without errors.  The success param is passed an array of CLBeaconRegions.
 @param failure executed when the network request fails.  The session and error are passed to the failure block.
 */
+ (void)getBeaconsWithSuccess:(void(^)(NSArray *beacons))success
                      failure:(void(^)(NSError *error))failure;

/**
 @param appId the application id for the app that you want to query beacons.
 @warning The appId must be an app id that is associated with your client id.
 @param success executed when the network request completes without errors.  The success param is passed an array of CLBeaconRegions.
 @param failure executed when the network request fails.  The session and error are passed to the failure block.
 */
+ (void)getBeaconsForAppId:(NSString *)appId
                   success:(void(^)(NSArray *beacons))success
                   failure:(void(^)(NSError *error))failure;


@end
