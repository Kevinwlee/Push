//
//  CarbonBlack.m
//  CarbonBlack
//
//  Created by Travis Fischer on 9/18/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CarbonBlack.h"
#import  <UIKit/UIKit.h>

@interface CarbonBlack ()
@property (nonatomic, strong) NSMutableArray *locationManagerDelegates;
@property (nonatomic, strong) NSString *appId;
@end

@implementation CarbonBlack

+ (CarbonBlack *)sharedInstance {
    static dispatch_once_t pred;
    static CarbonBlack *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[CarbonBlack alloc] init];
    });
    return shared;
}

+ (void)registerWithAppId:(NSString *)appId {
    if (!appId) {
        [NSException raise:NSInvalidArgumentException format:@"App ID cannot be nil"];
    }
    [CarbonBlack sharedInstance].appId = appId;

    [[CCBElementManifestService sharedService] getManifest];
}



+ (NSString *)applicationId {
    return [CarbonBlack sharedInstance].appId;
}

+ (NSString *)deviceId {
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}

+ (CLLocation *)currentLocation {
    CCBLocationService *svc = [CCBLocationService sharedService];
    return [svc currentLocation];
}


- (BOOL)addLocationManagerDelegate:(id <CLLocationManagerDelegate>)delegate {
    if (delegate == nil) {
        return NO;
    }
    
    if(!self.locationManagerDelegates) {
        self.locationManagerDelegates = [NSMutableArray array];
    }
    
    if (![self.locationManagerDelegates containsObject:delegate]) {
        [self.locationManagerDelegates addObject:delegate];
    }
    
    return YES;
}

- (BOOL)removeLocationManagerDelegate:(id<CLLocationManagerDelegate>)delegate {
    [self.locationManagerDelegates removeObject:delegate];
    return YES;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (id<CLLocationManagerDelegate> delegate in self.locationManagerDelegates) {
        if ([delegate respondsToSelector:@selector(locationManager:didUpdateLocations:)]) {
            [delegate locationManager:manager didUpdateLocations:locations];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    for (id<CLLocationManagerDelegate> delegate in self.locationManagerDelegates) {
        if ([delegate respondsToSelector:@selector(locationManager:didUpdateHeading:)]) {
            [delegate locationManager:manager didUpdateHeading:newHeading];
        }
    }
}

//Not sure what to do here for now I'm defaulting to NO
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return NO;
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    for (id<CLLocationManagerDelegate> delegate in self.locationManagerDelegates) {
        if ([delegate respondsToSelector:@selector(locationManager:didDetermineState:forRegion:)]) {
            [delegate locationManager:manager didDetermineState:state forRegion:region];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    for (id<CLLocationManagerDelegate> delegate in self.locationManagerDelegates) {
        if ([delegate respondsToSelector:@selector(locationManager:didRangeBeacons:inRegion:)]) {
            [delegate locationManager:manager didRangeBeacons:beacons inRegion:region];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    for (id<CLLocationManagerDelegate> delegate in self.locationManagerDelegates) {
        if ([delegate respondsToSelector:@selector(locationManager:rangingBeaconsDidFailForRegion:withError:)]) {
            [delegate locationManager:manager rangingBeaconsDidFailForRegion:region withError:error];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    for (id<CLLocationManagerDelegate> delegate in self.locationManagerDelegates) {
        if ([delegate respondsToSelector:@selector(locationManager:didEnterRegion:)]) {
            [delegate locationManager:manager didEnterRegion:region];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    for (id<CLLocationManagerDelegate> delegate in self.locationManagerDelegates) {
        if ([delegate respondsToSelector:@selector(locationManager:didExitRegion:)]) {
            [delegate locationManager:manager didExitRegion:region];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    for (id<CLLocationManagerDelegate> delegate in self.locationManagerDelegates) {
        if ([delegate respondsToSelector:@selector(locationManager:didFailWithError:)]) {
            [delegate locationManager:manager didFailWithError:error];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    for (id<CLLocationManagerDelegate> delegate in self.locationManagerDelegates) {
        if ([delegate respondsToSelector:@selector(locationManager:monitoringDidFailForRegion:withError:)]) {
            [delegate locationManager:manager monitoringDidFailForRegion:region withError:error];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    for (id<CLLocationManagerDelegate> delegate in self.locationManagerDelegates) {
        if ([delegate respondsToSelector:@selector(locationManager:didChangeAuthorizationStatus:)]) {
            [delegate locationManager:manager didChangeAuthorizationStatus:status];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    for (id<CLLocationManagerDelegate> delegate in self.locationManagerDelegates) {
        if ([delegate respondsToSelector:@selector(locationManager:didStartMonitoringForRegion:)]) {
            [delegate locationManager:manager didStartMonitoringForRegion:region];
        }
    }
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    for (id<CLLocationManagerDelegate> delegate in self.locationManagerDelegates) {
        if ([delegate respondsToSelector:@selector(locationManagerDidPauseLocationUpdates:)]) {
            [delegate locationManagerDidPauseLocationUpdates:manager];
        }
    }
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    for (id<CLLocationManagerDelegate> delegate in self.locationManagerDelegates) {
        if ([delegate respondsToSelector:@selector(locationManagerDidResumeLocationUpdates:)]) {
            [delegate locationManagerDidResumeLocationUpdates:manager];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didFinishDeferredUpdatesWithError:(NSError *)error {
    for (id<CLLocationManagerDelegate> delegate in self.locationManagerDelegates) {
        if ([delegate respondsToSelector:@selector(locationManager:didFinishDeferredUpdatesWithError:)]) {
            [delegate locationManager:manager didFinishDeferredUpdatesWithError:error];
        }
    }
}

@end
