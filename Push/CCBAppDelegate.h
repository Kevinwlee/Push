//
//  CCBAppDelegate.h
//  Push
//
//  Created by Kevin Lee on 1/13/14.
//  Copyright (c) 2014 ChaiONE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContextHub.h"
#import "CCHNotificationService.h"
#import "CCHContextEventManager.h"

@interface CCBAppDelegate : UIResponder <UIApplicationDelegate, CCBContextEventManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
