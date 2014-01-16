//
//  CarbonBlack.h
//  CarbonBlack
//
//  Created by Travis Fischer on 9/18/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CCBElementManifestService.h"
/**
 * The primary interface with the Carbon Black SDK
 */
@interface CarbonBlack : NSObject <CLLocationManagerDelegate>

/**
 * Returns the default instance of Cabon Black
 */
+ (CarbonBlack *)sharedInstance;

/**
 * Registers the app with Carbon. Call should be made on app launch.
 * @param appId The application's ID in the Carbon system.
 */
+ (void)registerWithAppId:(NSString *)appId;


/**
 * The application's ID registered with Carbon
 */
+ (NSString *)applicationId;

/**
 * The ID for the device
 */
+ (NSString *)deviceId;


/**
 returns the location from the Carbon location manager
 */
+ (CLLocation *)currentLocation;

- (BOOL)addLocationManagerDelegate:(id <CLLocationManagerDelegate>)delegate;
- (BOOL)removeLocationManagerDelegate:(id<CLLocationManagerDelegate>)delegate;

@end
