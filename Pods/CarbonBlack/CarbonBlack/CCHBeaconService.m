//
//  CCBBeaconService.m
//  ContextHub
//
//  Created by Kevin Lee on 11/7/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCHBeaconService.h"

#define kMajorKey @"major"
#define kMinorKey @"minor"
#define kNamekey @"name"
#define kUUIDkey @"udid"
#define kBeaconKey @"beacon"

@implementation CCHBeaconService

+ (void)getBeaconsWithSuccess:(void(^)(NSArray *beacons))success
                        failure:(void(^)(NSError *error))failure {
    
    [CCHBeaconProxy getBeaconsWithSuccess:^(id responseObject) {
        
        NSMutableArray *beacons = [NSMutableArray arrayWithCapacity:[responseObject count]];
        
        for (NSDictionary *beaconInfo in responseObject) {
            CLBeaconRegion *beacon = [CCHBeaconService regionForBeaconInfo:beaconInfo];
            [beacons addObject:beacon];
        }
        
        success(beacons);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)createBeacon:(CLBeaconRegion *)beacon withCompletion:(void(^)(BOOL successful, NSError *error))completion {
    
    NSDictionary *beaconInfo = [CCHBeaconService beaconInfoForBeacon:beacon];
    NSDictionary *params = @{kBeaconKey:beaconInfo};
    
    [CCHBeaconProxy createBeacon:params success:^(id responseObject) {
        completion(YES, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO, error);
    }];
}

+ (void)updateBeacon:(CLBeaconRegion *)beacon withCompletion:(void(^)(BOOL successful, NSError *error))completion {
    
    NSDictionary *beaconInfo = [CCHBeaconService beaconInfoForBeacon:beacon];
    NSDictionary *params = @{kBeaconKey:beaconInfo};
    
    [CCHBeaconProxy updateBeacon:params success:^(id responseObject) {
        completion(YES, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO, error);
    }];
}

#pragma mark - cross app methods

+ (void)getBeaconsForAppId:(NSString *)appId
                     success:(void(^)(NSArray *beacons))success
                     failure:(void(^)(NSError *error))failure {
    
    [CCHBeaconProxy getBeaconsForAppId:appId success:^(id responseObject) {
        
        NSMutableArray *beacons = [NSMutableArray arrayWithCapacity:[responseObject count]];
        
        for (NSDictionary *beaconInfo in responseObject) {
            CLBeaconRegion *beacon = [CCHBeaconService regionForBeaconInfo:beaconInfo];
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

+ (NSDictionary *)beaconInfoForBeacon:(CLBeaconRegion *)beacon {
    NSMutableDictionary *beaconInfo = [NSMutableDictionary dictionary];
    [beaconInfo setObject:beacon.identifier forKey:kNamekey];
    [beaconInfo setObject:[beacon.proximityUUID UUIDString] forKey:kUUIDkey];

    if (beacon.major) {
        [beaconInfo setObject:beacon.major forKey:kMajorKey];
    }
    
    if (beacon.minor) {
        [beaconInfo setObject:beacon.minor forKey:kMinorKey];
    }

    return beaconInfo;
}

@end
