//
//  CCBLocationService.m
//  CarbonBlack
//
//  Created by Kevin Lee on 10/24/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCBLocationService.h"
#import "CarbonBlack.h"

@interface CCBLocationService ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) BOOL trackingLocation;
@property (nonatomic) BOOL trackingGeofenceIn;
@property (nonatomic) BOOL trackingGeofenceOut;
@property (nonatomic) BOOL trackingBeaconIn;
@property (nonatomic) BOOL trackingBeaconOut;
@property (nonatomic) BOOL trackingBeaconChanged;
@property (nonatomic, strong) NSMutableDictionary *rangedRegions;

@end

@implementation CCBLocationService

+ (CCBLocationService *)sharedService {
    static CCBLocationService *__shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shared = [[CCBLocationService alloc] init];
    });
    
    return __shared;
}

- (CLLocation*)currentLocation {
    return self.locationManager.location;
}

- (NSDictionary *)contextInfoForLocationChange {
    NSDictionary *package = @{
                              @"device_id":[CarbonBlack deviceId],
                              @"latitude": [NSNumber numberWithDouble:self.locationManager.location ? self.locationManager.location.coordinate.latitude : 0.0] ,
                              @"longitude": [NSNumber numberWithDouble:self.locationManager.location ? self.locationManager.location.coordinate.longitude : 0.0],
                              @"altitude": [NSNumber numberWithDouble:self.locationManager.location ? self.locationManager.location.altitude : 0.0],
                              @"speed": [NSNumber numberWithDouble:self.locationManager.location ? self.locationManager.location.speed : 0.0],
                              @"course": [NSNumber numberWithDouble:self.locationManager.location ? self.locationManager.location.course : 0.0],
                              @"datetime": self.locationManager.location ? self.locationManager.location.timestamp : [NSDate date]
                              };
    return package;
}

- (NSDictionary *)contextInfoForRegion:(CLCircularRegion *)region transition:(NSString *)transition {
    NSDictionary *fenceInfo = @{@"state": transition,
                                @"fence": @{
                                        @"latitude": [NSNumber numberWithDouble:region.center.latitude],
                                        @"longitude": [NSNumber numberWithDouble:region.center.longitude],
                                        @"radius": [NSNumber numberWithDouble:region.radius],
                                        @"id": region.identifier
                                        }
                                };
    
    NSMutableDictionary *contextInfo = [NSMutableDictionary dictionaryWithDictionary:[self contextInfoForLocationChange]];
    [contextInfo addEntriesFromDictionary:fenceInfo];

    return contextInfo;
}

- (NSDictionary *)contextInfoForBeacon:(CLBeaconRegion *)beacon transition:(NSString *)transition {
    NSString *major = beacon.major? [beacon.major stringValue] : @"";
    NSString *minor = beacon.major? [beacon.minor stringValue] :@"";
    NSDictionary *fenceInfo = @{@"state": transition,
                                @"beacon": @{
                                        @"uuid": [beacon.proximityUUID UUIDString],
                                        @"major": major,
                                        @"minor": minor,
                                        @"name": beacon.identifier
                                        }
                                };
    
    NSMutableDictionary *contextInfo = [NSMutableDictionary dictionaryWithDictionary:[self contextInfoForLocationChange]];
    [contextInfo addEntriesFromDictionary:fenceInfo];
    
    return contextInfo;
}

- (NSDictionary *)contextInfoForRangedBeacon:(CLBeacon *)beacon proximity:(NSString *)proximity {
    NSString *major = beacon.major? [beacon.major stringValue] : @"";
    NSString *minor = beacon.major? [beacon.minor stringValue] :@"";
    NSDictionary *fenceInfo = @{@"state": proximity,
                                @"beacon": @{
                                        @"uuid": [beacon.proximityUUID UUIDString],
                                        @"major": major,
                                        @"minor": minor,
                                        @"proximity":proximity,
                                        @"rssi": [NSString stringWithFormat:@"%ld",(long)beacon.rssi]
                                        }
                                };
    
    NSMutableDictionary *contextInfo = [NSMutableDictionary dictionaryWithDictionary:[self contextInfoForLocationChange]];
    [contextInfo addEntriesFromDictionary:fenceInfo];
    
    return contextInfo;
}

- (NSDictionary *)contextInfoForDidEnterRegion:(CLCircularRegion *)region {
    return [self contextInfoForRegion:region transition:@"geofence_in"];
}

- (NSDictionary *)contextInfoForDidExitRegion:(CLCircularRegion *)region {
    return [self contextInfoForRegion:region transition:@"geofence_out"];
}

- (NSDictionary *)contextInfoForDidEnterBeacon:(CLBeaconRegion *)beacon {
    return [self contextInfoForBeacon:beacon transition:@"beacon_in"];
}

- (NSDictionary *)contextInfoForDidExitBeacon:(CLBeaconRegion *)beacon {
    return [self contextInfoForBeacon:beacon transition:@"beacon_out"];
}


#pragma mark - CCBElementServiceProtocol

- (BOOL)requestServiceAuthorizationForElement:(NSString *)element {
    
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    
    NSLog(@"Element %@", element);
    
    if ([element isEqualToString:kLocationChangedEvent]) {
        self.trackingLocation = YES;
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
    
    else if ([element isEqualToString:kGeofenceInEvent]) {
        self.trackingGeofenceIn = YES;
    }
    
    else if ([element isEqualToString:kGeofenceOutEvent]) {
        self.trackingGeofenceOut = YES;
    }
    
    else if ([element isEqualToString:kBeaconInEvent]) {
        self.trackingBeaconIn = YES;
    }

    else if ([element isEqualToString:kBeaconOutEvent]) {
        self.trackingBeaconOut = YES;
    }
    
    else if([element isEqualToString:kBeaconChangedEvent]) {
        self.trackingBeaconChanged = YES;
        self.rangedRegions = [NSMutableDictionary dictionary];
    }

    [self discoverRegions];
    
    return YES;
}

- (NSDictionary *)contextInfoForElement:(NSString *)element {
    

    if ([element isEqualToString:kLocationChangedEvent]) {
        return [self contextInfoForLocationChange];
    } else {
        return nil;
    }

    //TODO: only when app is active geofence_in, geofence_out, beacon_in, beacon_out
}

- (void)monitorRegionsForAppId:(NSString *)appId {
    [CCBGeofenceService getGeofencesForAppId:appId success:^(NSArray *fences) {
        [self registerRegionsToMonitor:fences];
    } failure:^(NSError *error) {
        NSLog(@"Geofence Service Error %@", error);
    }];
}

- (void)discoverRegions {
    if (self.trackingGeofenceIn || self.trackingGeofenceOut) {
        [CCBGeofenceService getGeofencesNearByWithSuccess:^(NSArray *fences){
            [self registerRegionsToMonitor:fences];
        } failure:^(NSError *error) {
            NSLog(@"Geofence Service Error %@", error);
        }];
        
    }
    
    if (self.trackingBeaconIn || self.trackingBeaconOut || self.trackingBeaconChanged) {
        [CCBBeaconService getBeaconsWithSuccess:^(NSArray *beacons) {
            [self registerBeaconsToMonitor:beacons];
        } failure:^(NSError *error) {
            NSLog(@"Beacon Service Error %@", error);
        }];
    }
}

- (void)registerRegionsToMonitor:(NSArray *)regions {
    for (CLCircularRegion *region in regions) {
        [self.locationManager startMonitoringForRegion:region];
    }
}

- (void)registerBeaconsToMonitor:(NSArray *)beaconRegions {
    for (CLBeaconRegion *region in beaconRegions) {
        [self.locationManager startMonitoringForRegion:region];
        if (self.trackingBeaconChanged) {
            [self.locationManager startRangingBeaconsInRegion:region];
        }
    }
}

- (void)stopMonitoringRegions {
    for (CLRegion *region in self.locationManager.monitoredRegions) {
        [self.locationManager stopMonitoringForRegion:region];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager did fail");
    [[CarbonBlack sharedInstance] locationManager:manager didFailWithError:error];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
            NSLog(@"Authorized");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"Denied");
            [manager stopMonitoringSignificantLocationChanges];
            [self stopMonitoringRegions];
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"NotDetermined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            [self stopMonitoringRegions];
            break;
        default:
            NSLog(@"Huh?");
            break;
    }
    
    [[CarbonBlack sharedInstance] locationManager:manager didChangeAuthorizationStatus:status];
}

- (void)triggerGeofenceInEvent:(CLCircularRegion *)region {
    NSDictionary *contextInfo = [self contextInfoForDidEnterRegion:region];
    
    NSDictionary *eventPackage = @{@"name":@"geofence_in", @"data":contextInfo};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"context_event_triggered" object:eventPackage];
    
    NSLog(@"%@", eventPackage);

}

- (void)triggerGeofenceOutEvent:(CLCircularRegion *)region {
    NSDictionary *contextInfo = [self contextInfoForDidExitRegion:(CLCircularRegion *)region];
    
    NSDictionary *eventPackage = @{@"name":@"geofence_out", @"data":contextInfo};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"context_event_triggered" object:eventPackage];
    
    NSLog(@"%@", eventPackage);

}

- (void)triggerBeaconInEvent:(CLBeaconRegion *)region {
    NSDictionary *contextInfo = [self contextInfoForDidEnterBeacon:region];
    
    NSDictionary *eventPackage = @{@"name":@"beacon_in", @"data":contextInfo};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"context_event_triggered" object:eventPackage];
    
    NSLog(@"%@", eventPackage);
}

- (void)triggerBeaconOutEvent:(CLBeaconRegion *)region {
    NSDictionary *contextInfo = [self contextInfoForDidExitBeacon:region];
    
    NSDictionary *eventPackage = @{@"name":@"beacon_out", @"data":contextInfo};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"context_event_triggered" object:eventPackage];
    
    NSLog(@"%@", eventPackage);

}

- (void)triggerRangedBeacon:(CLBeacon *)beacon inRegion:(CLBeaconRegion *)region proximity:(NSString *)proximity {
    NSDictionary *contextInfo = [self contextInfoForRangedBeacon:beacon proximity:proximity];
    NSDictionary *eventPackage = @{@"name":kBeaconChangedEvent, @"data":contextInfo};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"context_event_triggered" object:eventPackage];
    
    NSLog(@"%@", eventPackage);
}
#pragma mark - location events

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations {

    if (self.trackingLocation) {
        NSDictionary *data = [self contextInfoForLocationChange];
        NSDictionary *eventPackage = @{@"name":@"location_changed", @"data":data};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"context_event_triggered" object:eventPackage];
    
        NSLog(@"Did Update Location %@", eventPackage);
    }
    
    [[CarbonBlack sharedInstance] locationManager:manager didUpdateLocations:locations];
}

#pragma mark - region events

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {

    if ([region isKindOfClass:[CLCircularRegion class]]) {
        if (self.trackingGeofenceIn) {
            [self triggerGeofenceInEvent:(CLCircularRegion *)region];
        }
    } else {
        if (self.trackingBeaconIn) {
            [self triggerBeaconInEvent:(CLBeaconRegion *)region];
            [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
        }
    }
    
    [[CarbonBlack sharedInstance] locationManager:manager didEnterRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {

    if ([region isKindOfClass:[CLCircularRegion class]]) {
        if (self.trackingGeofenceOut) {
            [self triggerGeofenceOutEvent:(CLCircularRegion *)region];
        }
    } else {
        if (self.trackingBeaconOut) {
            [self triggerBeaconOutEvent:(CLBeaconRegion *)region];
            [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
        }
    }
    
    [[CarbonBlack sharedInstance] locationManager:manager didExitRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    for (CLBeacon *beacon in beacons) {
        NSString *beaconKey = [NSString stringWithFormat:@"%@_%@_%@", [beacon.proximityUUID UUIDString], beacon.major, beacon.minor];
        CCBRangedBeaconInfo *rangedBeaconInfo = [self.rangedRegions objectForKey:beaconKey];
        
        if (!rangedBeaconInfo) {
            rangedBeaconInfo =[[CCBRangedBeaconInfo alloc] init];
            [self.rangedRegions setObject:rangedBeaconInfo forKey:beaconKey];
        }
        
        switch (beacon.proximity) {
            case CLProximityFar:
                rangedBeaconInfo.far ++;
                break;
            case CLProximityNear:
                rangedBeaconInfo.near ++;
                break;
            case CLProximityImmediate:
                rangedBeaconInfo.immediate++;
                break;
            default:
                break;
        }
        
        NSUInteger threshold = 3;
        if (rangedBeaconInfo.far == threshold ) {
            rangedBeaconInfo.near = 0;
            rangedBeaconInfo.immediate = 0;
            rangedBeaconInfo.currentState = CLProximityFar;
            [self triggerRangedBeacon:beacon inRegion:region proximity:kBeaconProximityFar];
        } else if (rangedBeaconInfo.near == threshold){
            rangedBeaconInfo.far = 0;
            rangedBeaconInfo.immediate = 0;
            rangedBeaconInfo.currentState = CLProximityNear;
            [self triggerRangedBeacon:beacon inRegion:region proximity:kBeaconProximityNear];
        } else if (rangedBeaconInfo.immediate == threshold){
            rangedBeaconInfo.far = 0;
            rangedBeaconInfo.near = 0;
            rangedBeaconInfo.currentState = CLProximityImmediate;
            [self triggerRangedBeacon:beacon inRegion:region proximity:kBeaconProximityImmediate];
        }
        
        [self.rangedRegions setObject:rangedBeaconInfo forKey:beaconKey];
    }
    
    [[CarbonBlack sharedInstance] locationManager:manager didRangeBeacons:beacons inRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading {
    [[CarbonBlack sharedInstance] locationManager:manager didUpdateHeading:newHeading];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    [[CarbonBlack sharedInstance] locationManagerShouldDisplayHeadingCalibration:manager];
    return NO;
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    [[CarbonBlack sharedInstance] locationManager:manager didDetermineState:state forRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager
    rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error {
    [[CarbonBlack sharedInstance] locationManager:manager rangingBeaconsDidFailForRegion:region withError:error];
}

- (void)locationManager:(CLLocationManager *)manager
    monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error {
    [[CarbonBlack sharedInstance] locationManager:manager monitoringDidFailForRegion:region withError:error];
}

- (void)locationManager:(CLLocationManager *)manager
    didStartMonitoringForRegion:(CLRegion *)region {
    [[CarbonBlack sharedInstance] locationManager:manager didStartMonitoringForRegion:region];
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    [[CarbonBlack sharedInstance] locationManagerDidPauseLocationUpdates:manager];
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    [[CarbonBlack sharedInstance] locationManagerDidResumeLocationUpdates:manager];
}

- (void)locationManager:(CLLocationManager *)manager
    didFinishDeferredUpdatesWithError:(NSError *)error {
    [[CarbonBlack sharedInstance] locationManager:manager didFinishDeferredUpdatesWithError:error];
}

@end
