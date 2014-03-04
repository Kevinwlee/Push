//
//  CCBMotionService.m
//  ContextHub
//
//  Created by Kevin Lee on 12/13/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCHMotionService.h"

/**
 Posted when an operation a motion change is detected.
 */
NSString * const CCHMotionChangedNotification = @"CCHMotionChangedNotification";

@interface CCHMotionService ()
@property (nonatomic, strong) CMMotionActivityManager *motionActivityManager;
@property (nonatomic, strong) NSOperationQueue *activityMonitorQueue;
@property (nonatomic, strong) CMMotionActivity *previousActivity;
@property (nonatomic, strong) CMMotionActivity *currentActivity;
@end

@implementation CCHMotionService

+ (CCHMotionService *)sharedService {
    static CCHMotionService *__shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shared = [[CCHMotionService alloc] init];
    });
    
    return __shared;
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnOffMotionServices) name:@"disable_motion_notification" object:nil];
    }
    return self;
}

- (NSDictionary *)authorizationStatus {
    NSString *status = [CMMotionActivityManager isActivityAvailable] ? @"true":@"false";
    return @{@"motion":status};
}

- (NSString *)contextKey {
    return @"motion_context";
}

- (BOOL)requestServiceAuthorizationForElement:(NSString *)element {

    if ([CMMotionActivityManager isActivityAvailable]) {
        self.motionActivityManager = [[CMMotionActivityManager alloc] init];
        self.activityMonitorQueue = [[NSOperationQueue alloc] init];
        [self startTrackingMotionActivity];
        return YES;
        
    }
    return NO;
}

- (NSDictionary *)contextInfoForElement:(NSString *)element {
    NSMutableDictionary *contextInfo = [NSMutableDictionary dictionary];
    if (self.previousActivity) {
        NSArray *activities = [self activiesFromActivity:self.previousActivity];
        NSDictionary *previous = @{@"confidence": [NSNumber numberWithInt:self.previousActivity.confidence],
                                   @"start_date":self.previousActivity.startDate,
                                   @"activities":activities};
        
        [contextInfo setObject:previous forKey:@"previous_activity"];
    }
    if (self.currentActivity) {
        NSArray *activities = [self activiesFromActivity:self.currentActivity];
        NSDictionary *current = @{@"confidence": [NSNumber numberWithInt:self.currentActivity.confidence],
                                   @"start_date":self.currentActivity.startDate,
                                   @"activities":activities};
        
        [contextInfo setObject:current forKey:@"current_activity"];
    }
    
    return contextInfo;
}

- (NSArray *)activiesFromActivity:(CMMotionActivity *)activity {
    NSMutableArray *activities = [NSMutableArray array];
    if (activity.unknown) {
        [activities addObject:@"unknown"];
    }
    
    if (activity.walking) {
        [activities addObject:@"walking"];
    }
    
    if (activity.running) {
        [activities addObject:@"running"];
    }
    
    if (activity.automotive) {
        [activities addObject:@"automotive"];
    }
    
    if (activity.stationary) {
        [activities addObject:@"stationary"];
    }
    
    return activities;
}

- (void)startTrackingMotionActivity {
    [self.motionActivityManager startActivityUpdatesToQueue:self.activityMonitorQueue withHandler:^(CMMotionActivity *activity) {
        [self updateCurrentActivity:activity];
        [self triggerMotionChangedEvent];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CCHMotionChangedNotification object:activity];
        
        if (activity.unknown) {
            NSLog(@"unknown");
        }
        
        if (activity.walking) {
            NSLog(@"walking");
        }
        
        if (activity.running) {
            NSLog(@"running");
        }
        
        if (activity.automotive) {
            NSLog(@"automotive");
        }
        
        if (activity.stationary) {
            NSLog(@"stationary");
        }
        
    }];
}

- (void)updateCurrentActivity:(CMMotionActivity *)activity {
    self.previousActivity = self.currentActivity;
    self.currentActivity = activity;
}

- (void)triggerMotionChangedEvent{
    NSDictionary *contextInfo = [self contextInfoForElement:nil];
    
    NSDictionary *eventPackage = @{@"name":kMotionChangedEvent, @"data":contextInfo};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"context_event_triggered" object:eventPackage];
    
    NSLog(@"%@", eventPackage);

}

- (void)turnOffMotionServices {
    [self.motionActivityManager stopActivityUpdates];
}


@end
