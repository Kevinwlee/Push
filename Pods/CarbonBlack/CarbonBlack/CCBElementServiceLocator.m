//
//  CCBElementServiceLocator.m
//  CarbonBlack
//
//  Created by Kevin Lee on 10/24/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCBElementServiceLocator.h"


@interface CCBElementServiceLocator ()
@property (nonatomic, strong) NSMutableDictionary *elementServices;
@end

@implementation CCBElementServiceLocator

+ (CCBElementServiceLocator *) sharedLocator {
    static CCBElementServiceLocator *__shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shared = [[CCBElementServiceLocator alloc] init];
    });
    return __shared;
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.elementServices = [NSMutableDictionary dictionary];
        [self registerService:[CCBLocationService sharedService] forElement:kGeofenceInEvent];
        [self registerService:[CCBLocationService sharedService] forElement:kGeofenceOutEvent];
        [self registerService:[CCBLocationService sharedService] forElement:kLocationChangedEvent];
        [self registerService:[CCBLocationService sharedService] forElement:kBeaconInEvent];
        [self registerService:[CCBLocationService sharedService] forElement:kBeaconOutEvent];
        [self registerService:[CCBLocationService sharedService] forElement:kBeaconChangedEvent];
        [self registerService:[CCBMotionService sharedService] forElement:kMotionChangedEvent];
        [self registerService:[CCBDeviceInformationService sharedService]forElement:kDeviceInfo];
    }

    return self;
}


- (void)registerService:(id<CCBElementServiceProtocol>)elementService forElement:(NSString *)element {
    [self.elementServices setObject:elementService forKey:element];
    NSString *notificationName = [NSString stringWithFormat:@"%@_required_notification", element];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:notificationName object:nil];
}


- (id<CCBElementServiceProtocol>)elementServiceForName:(NSString *)name {
    return [self.elementServices objectForKey:name];
}


- (void)handleNotification:(NSNotification *)notification {
    NSString *element = notification.object;
    id<CCBElementServiceProtocol> svc = [self.elementServices objectForKey:element];
    [svc requestServiceAuthorizationForElement:element];
}

- (NSArray *)registeredServices {
    NSMutableArray *elements= [NSMutableArray array];

    for (NSString *key in self.elementServices.allKeys) {
       [elements addObject:[self.elementServices objectForKey:key]];
    }
    
    return elements;
}

- (NSMutableArray *)contextInformation {
    NSMutableArray *context = [NSMutableArray array];

    for (NSString *key in self.elementServices.allKeys) {
        id<CCBElementServiceProtocol> svc = [self.elementServices objectForKey:key];
        NSDictionary *contextInfo =[svc contextInfoForElement:key];
        if (contextInfo) {
            [context addObject:@{key:contextInfo}];
        }
    }

    return context;
}

@end
