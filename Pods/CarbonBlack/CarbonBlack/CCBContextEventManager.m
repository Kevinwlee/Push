//
//  CCBContextEventManager.m
//  CarbonBlack
//
//  Created by Kevin Lee on 10/25/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCBContextEventManager.h"

@implementation CCBContextEventManager
//listens for context events
//polls all the services for their context packages
//posts events to Event Proxy

+ (CCBContextEventManager *)sharedManager {
    static CCBContextEventManager *__shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shared = [[CCBContextEventManager alloc] init];
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
    
    NSDictionary *payload = [self payloadForEvent:event];
    
    NSArray *context = [self contextInformation];
    
    NSDictionary *eventPackage = @{@"event":@{
                                           @"name":[event objectForKey:@"name"],
                                           @"data": [event objectForKey:@"data"],
                                           @"context":context,
                                           @"payload":payload }
                                   };

    [self willPostEventPackage:eventPackage];
    
    [CCBEventProxy postEventPackage:eventPackage success:^(id responseObject) {
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
    CCBElementServiceLocator *locator = [CCBElementServiceLocator sharedLocator];
    return [locator contextInformation];
}

#pragma mark - datasource calls

- (NSDictionary *)payloadForEvent:(NSDictionary *)event {
    NSDictionary *payload = [NSDictionary dictionary];
    
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(payloadForEvent:)]) {
            payload = [self.dataSource payloadForEvent:event];
        }
        if ([self.dataSource respondsToSelector:@selector(contextEventMangaer:payloadForEvent:)]) {
            payload = [self.dataSource contextEventMangaer:self payloadForEvent:event];
        }
    } else {
        payload = @{};
    }
    
    return payload;
}

#pragma mark - delegate calls

- (void)willPostEventPackage:(NSDictionary *)eventPackage {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(willPostEvent:)]) {
            [self.delegate willPostEvent:eventPackage];
        }
        if ([self.delegate respondsToSelector:@selector(contextEventMangaer:willPostEvent:)]) {
            [self.delegate contextEventMangaer:self didPostEvent:eventPackage];
        }
    }
}

- (void)didPostEventPackage:(NSDictionary *)eventPackage {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didPostEvent:)]) {
            [self.delegate didPostEvent:eventPackage];
        }
        
        if ([self.delegate respondsToSelector:@selector(contextEventMangaer:didPostEvent:)]) {
            [self.delegate contextEventMangaer:self didPostEvent:eventPackage];
        }
    }
}

@end

