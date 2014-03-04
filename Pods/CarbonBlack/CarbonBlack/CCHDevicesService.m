//
//  CCBDevicesService.m
//  ContextHub
//
//  Created by Kevin Lee on 2/12/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "CCHDevicesService.h"


@implementation CCHDevicesService

+ (void)registerDevice {
    
    NSDictionary *deviceInfo = [CCHDevicesService deviceInformation];
    
    [CCHDevicesProxy patchDevice:deviceInfo success:^(id responseObject) {
        NSLog(@"device registered");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error registering device");
    }];
}


+ (NSDictionary *)deviceInformation {
    NSDictionary *deviceInformation = [[CCHDeviceInformationService sharedService] deviceInformation];
    NSDictionary *serviceAuthorization = [CCHDevicesService serviceAuthorizationStatus];
    
    if (!serviceAuthorization) {
        return deviceInformation;
    }
        
    NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionaryWithDictionary:deviceInformation];
    [deviceInfo addEntriesFromDictionary:serviceAuthorization];
    return deviceInfo;
    
}

+ (NSDictionary *)serviceAuthorizationStatus {
    NSMutableDictionary *authStatus = [NSMutableDictionary dictionary];
    NSArray *services = [[CCHElementServiceLocator sharedLocator] registeredServices];
    for (id<CCHElementServiceProtocol> service in services) {
        NSDictionary *status = [service authorizationStatus];
        if (status) {
            [authStatus addEntriesFromDictionary:[service authorizationStatus]];
        }
        
    }
    return authStatus;
}

@end
