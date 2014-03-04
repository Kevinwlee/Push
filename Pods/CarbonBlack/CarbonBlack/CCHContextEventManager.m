//
//  CCBContextEventManager.m
//  ContextHub
//
//  Created by Kevin Lee on 10/25/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCHContextEventManager.h"

/**
 Posted before an event is posted to ContextHub
 */
NSString * const CCHContextEventManagerWillPostEvent = @"CCHContextEventManagerWillPostEvent";

/**
 Posted after an event has been posted to ContextHub
 */
NSString * const CCHContextEventManagerDidPostEvent = @"CCHContextEventManagerDidPostEvent";

/**
 Posted when the event was cancelled.
 */
NSString * const CCHContextEventManagerDidCancelEvent = @"CCHContextEventManagerDidCancelEvent";

/**
 Posted when an event is detected.
 */
NSString * const CCHContextEventManagerDidDetectEvent = @"CCHContextEventManagerDidDetectEvent";


@implementation CCHContextEventManager
//listens for context events
//polls all the services for their context packages
//posts events to Event Proxy

+ (CCHContextEventManager *)sharedManager {
    static CCHContextEventManager *__shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shared = [[CCHContextEventManager alloc] init];
    });
    
    return __shared;
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleContextEvent:) name:@"context_event_triggered" object:nil];
    }
    return self;
}

- (void)handleContextEvent:(NSNotification *)notification {
    
    NSDictionary *event = notification.object;

    [[NSNotificationCenter defaultCenter] postNotificationName:CCHContextEventManagerDidDetectEvent object:event];
    
    NSDictionary *payload = [self payloadForEvent:event];
    
    NSArray *context = [self contextInformation];
    
    NSDictionary *eventPackage = @{@"event":@{
                                           @"name":[event objectForKey:@"name"],
                                           @"data": [event objectForKey:@"data"],
                                           @"context":context,
                                           @"payload":payload }
                                   };
    
    if ([self shouldPostEventPackage:eventPackage]) {
        [self postEventPackage:eventPackage];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:CCHContextEventManagerDidCancelEvent object:eventPackage];
    }
}

- (void)postEventPackage:(NSDictionary *)eventPackage {
    [self willPostEventPackage:eventPackage];
    
    [CCHEventProxy postEventPackage:eventPackage success:^(id responseObject) {
        NSLog(@"SUCCESS Event Posted %@", responseObject);
        [self didPostEventPackage:eventPackage];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"FAILED Event Posted");
        [self didPostEventPackage:eventPackage];
        NSLog(@"Task %@", task);
        NSLog(@"Error %@", error);
    }];
}

- (NSArray *)contextInformation {
    CCHElementServiceLocator *locator = [CCHElementServiceLocator sharedLocator];
    return [locator contextInformation];
}

#pragma mark - datasource calls

- (NSDictionary *)payloadForEvent:(NSDictionary *)event {
    NSDictionary *payload = [NSDictionary dictionary];
    
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(payloadForEvent:)]) {
            payload = [self.dataSource payloadForEvent:event];
        }
        if ([self.dataSource respondsToSelector:@selector(contextEventManager:payloadForEvent:)]) {
            payload = [self.dataSource contextEventManager:self payloadForEvent:event];
        }
    } else {
        payload = @{};
    }
    
    return payload;
}

#pragma mark - delegate calls

- (BOOL)shouldPostEventPackage:(NSDictionary *)eventPackage {
    if (!self.delegate) {
        return YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(contextEventManager:shouldPostEvent:)]) {
        return [self.delegate contextEventManager:self shouldPostEvent:eventPackage];
    } else {
        return YES;
    }
}

- (void)willPostEventPackage:(NSDictionary *)eventPackage {

    [[NSNotificationCenter defaultCenter] postNotificationName:CCHContextEventManagerWillPostEvent object:eventPackage];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(willPostEvent:)]) {
            [self.delegate willPostEvent:eventPackage];
        }
        if ([self.delegate respondsToSelector:@selector(contextEventManager:willPostEvent:)]) {
            [self.delegate contextEventManager:self didPostEvent:eventPackage];
        }
    }
}

- (void)didPostEventPackage:(NSDictionary *)eventPackage {
    [[NSNotificationCenter defaultCenter] postNotificationName:CCHContextEventManagerDidPostEvent object:eventPackage];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didPostEvent:)]) {
            [self.delegate didPostEvent:eventPackage];
        }
        
        if ([self.delegate respondsToSelector:@selector(contextEventManager:didPostEvent:)]) {
            [self.delegate contextEventManager:self didPostEvent:eventPackage];
        }
    }
}

@end

