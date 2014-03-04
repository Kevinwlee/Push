//
//  CCBDeviceInformationService.m
//  ContextHub
//
//  Created by Kevin Lee on 12/16/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCHDeviceInformationService.h"

@implementation CCHDeviceInformationService

+ (CCHDeviceInformationService *)sharedService {
    static CCHDeviceInformationService * __shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shared = [[CCHDeviceInformationService alloc] init];
    });
    return __shared;
}

- (BOOL)requestServiceAuthorizationForElement:(NSString *)element {
    
    return YES;
}

- (NSDictionary *)deviceInformation {
    return [self contextInfoForElement:nil];
}

- (NSDictionary *)contextInfoForElement:(NSString *)element {
    UIDevice *device = [UIDevice currentDevice];
    NSString *type = [self deviceTypeFromUserInterfaceIdiom:device.userInterfaceIdiom];
    NSDictionary *deviceInfo = @{@"device_id": [device.identifierForVendor UUIDString],
      @"type":type,
      @"name":device.name,
      @"system_name":device.systemName,
      @"system_version":device.systemVersion,
      @"model":device.model
      };
    return deviceInfo;
}

- (NSString *)deviceTypeFromUserInterfaceIdiom:(UIUserInterfaceIdiom)idom {
    switch (idom) {
        case UIUserInterfaceIdiomPad:
            return @"iPad";
            break;
            case UIUserInterfaceIdiomPhone:
            return @"iPhone";
            break;
        default:
            return @"unknown";
            break;
    }
}

- (NSDictionary *)authorizationStatus {
    return nil;
}

- (NSString *)contextKey {
    return @"device_context";
}
@end
