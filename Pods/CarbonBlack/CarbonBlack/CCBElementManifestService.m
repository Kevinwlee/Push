//
//  CCBContextManifest.m
//  CarbonBlack
//
//  Created by Kevin Lee on 10/23/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCBElementManifestService.h"

#define kElementsKey @"context_events"

@interface CCBElementManifestService ()
@property (nonatomic, strong) NSArray *elementManifest;
@end

@implementation CCBElementManifestService

+ (CCBElementManifestService *)sharedService {
    static CCBElementManifestService *__shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shared = [[CCBElementManifestService alloc] init];
    });
    
    return __shared;
}

- (id)init {
    self = [super init];
    if (self) {
        self.elementManifest = [NSArray array];
    }
    //TODO:figure out where to start the Locator?
    //I don't like these dependencies here.
    [CCBElementServiceLocator sharedLocator];
    [CCBContextEventManager sharedManager];
    return self;
}

- (void)getManifest {
    [CCBManifestProxy getManifestWithSuccess:^(id responseObject) {
        
        [self processManifest:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Manifest Task :%@", task);
        NSLog(@"Manifest Error: %@", error);
        
    }];
}

- (void)processManifest:(NSDictionary *)manifest {
    self.elementManifest = [manifest objectForKey:kElementsKey];
    [self registerElements:self.elementManifest];
}

- (void)registerElements:(NSArray *)elements{
    for (NSString *element in elements) {
        NSString *notificationName = [NSString stringWithFormat:@"%@_required_notification", element];
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:element];
    }
}


@end
