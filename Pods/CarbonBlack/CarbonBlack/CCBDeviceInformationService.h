//
//  CCBDeviceInformationService.h
//  CarbonBlack
//
//  Created by Kevin Lee on 12/16/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIDevice.h>
#import "CCBElementServiceProtocol.h"

#define kDeviceInfo @"device_information"
/**
Wraps common device information so that it can be easily assembled in context event packages.
 */
@interface CCBDeviceInformationService : NSObject <CCBElementServiceProtocol>

/**
 returns the static shared instance of the device information service
 */
+ (CCBDeviceInformationService *)sharedService;

@end
