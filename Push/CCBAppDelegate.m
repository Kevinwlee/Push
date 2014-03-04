//
//  CCBAppDelegate.m
//  Push
//
//  Created by Kevin Lee on 1/13/14.
//  Copyright (c) 2014 ChaiONE. All rights reserved.
//

#import "CCBAppDelegate.h"


@implementation CCBAppDelegate 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [ContextHub registerWithAppId:@"49f76a62-013a-4bfb-870d-ed04d040254e"];

    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound ];

    if (application.backgroundRefreshStatus == UIBackgroundRefreshStatusAvailable) {
        NSLog(@"Background refresh enabled");
    }
    
    NSLog(@"Launch Options %@", launchOptions);
    
    [[CCHContextEventManager sharedManager] setDelegate:self];
    
    return YES;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did fail to register %@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    CCHNotificationService *sharedService = [CCHNotificationService sharedService];
	NSString *deviceID = [ContextHub deviceId];
	
    [sharedService registerDeviceToken:deviceToken withAlias:deviceID withCompletion:^(NSError *error) {
        if(error) {
            NSLog(@"%@", error);
        } else {
            NSString *token = [[[[deviceToken description]
                                        stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                       stringByReplacingOccurrencesOfString: @">" withString: @""]
                                      stringByReplacingOccurrencesOfString: @" " withString: @""];
            NSLog(@"%@",token);
        }
    }];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"DEBUG: Did receive remote notification! %@", userInfo);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:42];
    [ContextHub application:application didReceiveRemoteNotification:userInfo completion:^(UIBackgroundFetchResult backgroundFetchResult) {
        [self updateCounter];
        [self handleCustomData:userInfo];

        NSLog(@"DEBUG: Completed background handler");
        completionHandler(UIBackgroundFetchResultNoData);
    }];
    
    
}

- (void)updateCounter {
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:@"counter"];
    count ++;
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"counter"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"count_updated" object:nil];
}

- (void)handleCustomData:(NSDictionary *)userInfo {
    [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"custom"] forKey:@"custom_data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"data_updated" object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)contextEventManager:(CCHContextEventManager *)eventManager
            shouldPostEvent:(NSDictionary *)event {
    NSLog(@"event %@", event);
    return YES;
}

@end
