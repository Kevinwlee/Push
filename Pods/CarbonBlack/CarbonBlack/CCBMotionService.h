//
//  CCBMotionService.h
//  CarbonBlack
//
//  Created by Kevin Lee on 12/13/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "CCBElementServiceProtocol.h"

#define kMotionChangedEvent @"motion_changed"
/**
 The CCBMotionService uses a CMMotionActivityManager to track and register motion activities.
 
 This class implements the CCBElementServiceProtocol.
 */
@interface CCBMotionService : NSObject <CCBElementServiceProtocol>

/**
 returs a static shared instnace of the CCBMotionService
 */

+ (CCBMotionService *)sharedService;
@end
