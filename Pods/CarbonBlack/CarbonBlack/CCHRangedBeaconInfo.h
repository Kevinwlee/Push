//
//  CCBRangedBeaconInfo.h
//  ContextHub
//
//  Created by Kevin Lee on 12/20/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CCHRangedBeaconInfo : NSObject
@property (nonatomic, strong) NSString *regionId;
@property (nonatomic) NSUInteger near;
@property (nonatomic) NSUInteger far;
@property (nonatomic) NSUInteger immediate;
@property (nonatomic) CLRegionState currentState;
@end
