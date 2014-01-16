//
//  CCBBeaconService.m
//  CarbonBlack
//
//  Created by Kevin Lee on 11/7/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCBBeaconService.h"

#define kMajorKey @"major"
#define kMinorKey @"minor"
#define kNamekey @"name"
#define kUUIDkey @"udid"

@implementation CCBBeaconService

+ (void)getBeaconsWithSuccess:(void(^)(NSArray *beacons))success
                        failure:(void(^)(NSError *error))failure {
    
    [CCBBeaconProxy getBeaconsWithSuccess:^(id responseObject) {
        
        NSMutableArray *beacons = [NSMutableArray arrayWithCapacity:[responseObject count]];
        
        for (NSDictionary *beaconInfo in responseObject) {
            CLBeaconRegion *beacon = [CCBBeaconService regionForBeaconInfo:beaconInfo];
            [beacons addObject:beacon];
        }
        
        success(beacons);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)getBeaconsForAppId:(NSString *)appId
                     success:(void(^)(NSArray *beacons))success
                     failure:(void(^)(NSError *error))failure {
    
    [CCBBeaconProxy getBeaconsForAppId:appId success:^(id responseObject) {
        
        NSMutableArray *beacons = [NSMutableArray arrayWithCapacity:[responseObject count]];
        
        for (NSDictionary *beaconInfo in responseObject) {
            CLBeaconRegion *beacon = [CCBBeaconService regionForBeaconInfo:beaconInfo];
            [beacons addObject:beacon];
        }
        
        success(beacons);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (CLBeaconRegion *)regionForBeaconInfo:(NSDictionary *)beaconInfo {
    NSLog(@"Beacon Info %@", beaconInfo);
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:[beaconInfo objectForKey:kUUIDkey]];
    NSString *identifier = [beaconInfo objectForKey:kNamekey];
    NSString *majorValue =[beaconInfo objectForKey:kMajorKey];
    NSString *minorValue = [beaconInfo objectForKey:kMinorKey];
    
    if ([majorValue isEqual:[NSNull null]]) {
        CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                          identifier:identifier];
        return beaconRegion;
    } else if (![majorValue isEqual:[NSNull null]] && [minorValue isEqual:[NSNull null]]) {
        CLBeaconMajorValue major = [majorValue integerValue];
        
        CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                               major:major
                                                                          identifier:identifier];
        return beaconRegion;
    } else {
        CLBeaconMajorValue major = [majorValue integerValue];
        CLBeaconMinorValue minor = [minorValue integerValue];
        
        CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                               major:major
                                                                               minor:minor
                                                                          identifier:identifier];
        return beaconRegion;
    }
}

@end
