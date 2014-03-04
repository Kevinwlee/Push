//
//  CCBElementServiceLocator.m
//  ContextHub
//
//  Created by Kevin Lee on 10/24/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCHElementServiceLocator.h"


@interface CCHElementServiceLocator ()
@property (nonatomic, strong) NSMutableDictionary *elementServices;
@end

@implementation CCHElementServiceLocator

+ (CCHElementServiceLocator *) sharedLocator {
    static CCHElementServiceLocator *__shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shared = [[CCHElementServiceLocator alloc] init];
    });
    return __shared;
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.elementServices = [NSMutableDictionary dictionary];
        [self registerService:[CCHLocationService sharedService] forElement:kGeofenceInEvent];
        [self registerService:[CCHLocationService sharedService] forElement:kGeofenceOutEvent];
        [self registerService:[CCHLocationService sharedService] forElement:kLocationChangedEvent];
        [self registerService:[CCHLocationService sharedService] forElement:kBeaconInEvent];
        [self registerService:[CCHLocationService sharedService] forElement:kBeaconOutEvent];
        [self registerService:[CCHLocationService sharedService] forElement:kBeaconChangedEvent];
        [self registerService:[CCHMotionService sharedService] forElement:kMotionChangedEvent];
        [self registerService:[CCHDeviceInformationService sharedService]forElement:kDeviceInfo];
    }

    return self;
}


- (void)registerService:(id<CCHElementServiceProtocol>)elementService forElement:(NSString *)element {
    [self.elementServices setObject:elementService forKey:element];
    NSString *notificationName = [NSString stringWithFormat:@"%@_required_notification", element];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:notificationName object:nil];
}


- (id<CCHElementServiceProtocol>)elementServiceForName:(NSString *)name {
    return [self.elementServices objectForKey:name];
}


- (void)handleNotification:(NSNotification *)notification {
    NSString *element = notification.object;
    id<CCHElementServiceProtocol> svc = [self.elementServices objectForKey:element];
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
    
    NSMutableArray *queriedElementServices = [NSMutableArray array];
    
    //Loop over the services and get their context info.  Only ask each service object once.
    for (NSString *key in self.elementServices.allKeys) {
        
        id<CCHElementServiceProtocol> svc = [self.elementServices objectForKey:key];
        
        if (![queriedElementServices containsObject:svc]) {
            [queriedElementServices addObject:svc];

            NSDictionary *contextInfo =[svc contextInfoForElement:key];
            if (contextInfo) {
                [context addObject:@{svc.contextKey:contextInfo}];
            }
            
        }
        
    }

    return context;
}

@end
