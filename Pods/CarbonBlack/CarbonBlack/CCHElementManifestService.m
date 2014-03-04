//
//  CCBContextManifest.m
//  ContextHub
//
//  Created by Kevin Lee on 10/23/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCHElementManifestService.h"

#define kElementsKey @"context_events"

@interface CCHElementManifestService ()
@property (nonatomic, strong) NSArray *elementManifest;
@end

@implementation CCHElementManifestService

+ (CCHElementManifestService *)sharedService {
    static CCHElementManifestService *__shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shared = [[CCHElementManifestService alloc] init];
    });
    
    return __shared;
}

- (id)init {
    self = [super init];
    if (self) {
        self.elementManifest = [NSArray array];
    }
    
    [CCHElementServiceLocator sharedLocator];
    [CCHContextEventManager sharedManager];

    return self;
}

- (void)getManifest {
    [self getManifestWithcompletion:nil];
}

- (void)getManifestWithcompletion:(void(^)(BOOL didFetchContent))completion {

    [CCHManifestProxy getManifestWithSuccess:^(id responseObject) {
    
        [self processManifest:responseObject completion:^(BOOL complete) {
            if (completion) {
                [self performSelector:@selector(executeCompletion:) withObject:completion afterDelay:8];
            }
        }];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (completion) {
            completion(NO);
        }
        
        NSLog(@"Manifest Error: %@", error);
    }];
}

- (void)executeCompletion:(void(^)(BOOL complete))completion {
    completion(YES);
}

- (void)processManifest:(NSDictionary *)manifest {
    [self processManifest:manifest completion:nil];
}

- (void)processManifest:(NSDictionary *)manifest completion:(void(^)(BOOL complete))completion {
    self.elementManifest = [manifest objectForKey:kElementsKey];
    
    [self registerElements:self.elementManifest];
    
    [self unregisterMissingElements:self.elementManifest];
    
    if (completion) {
        completion (YES);
    }
    
}

- (void)registerElements:(NSArray *)elements{
    for (NSString *element in elements) {
        NSString *notificationName = [NSString stringWithFormat:@"%@_required_notification", element];
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:element];
    }
}

- (void)unregisterMissingElements:(NSArray *)elements {
    NSPredicate *motionPredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] 'motion'"];
    NSArray *motionResult = [elements filteredArrayUsingPredicate:motionPredicate];
    if (motionResult.count == 0) {
        NSLog(@"Turn Off Motion");
        NSString *notificationName = @"disable_motion_notification";
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
        
    }
    
    NSPredicate *locationPredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] 'location'" ];
    NSArray *locationResult = [elements filteredArrayUsingPredicate:locationPredicate];
    if (locationResult.count == 0) {
        NSLog(@"Turn Off Location");
        NSString *notificationName = @"disable_location_notification";
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
    }
    
    NSPredicate *regionPredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] 'geofence' OR SELF BEGINSWITH[cd] 'beacon'" ];
    NSArray *regionResult = [elements filteredArrayUsingPredicate:regionPredicate];
    if (regionResult.count == 0) {
        NSLog(@"Turn Off Region");
        NSString *notificationName = @"disable_region_notification";
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
    }
}

@end
