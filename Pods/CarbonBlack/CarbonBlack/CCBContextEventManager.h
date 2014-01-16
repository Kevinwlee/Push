//
//  CCBContextEventManager.h
//  CarbonBlack
//
//  Created by Kevin Lee on 10/25/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCBEventProxy.h"
#import "CCBElementServiceLocator.h"


/**
 The context event manager listens for context_event_triggered notifications.  
 When a notification is received, the manager creates the event package from 
 the notification object. 

 
 Once the event package is assembled, it will post the data using the CCBEventProxy.
 
 @warning not implemented - it then queries the EventServiceLocator for all of the
 registered services.  It builds the a context package from the services. 
 
 @warning not implemented - Finally it asks it's delegates for userdefined payload.
 
 @warning not implemented -  During the process it will call delegate lifecycle methods and post lifecycle notifications.
*/
@interface CCBContextEventManager : NSObject
/** 
 returns the static instnace of the CCBContextEventManager
 */
+ (CCBContextEventManager *)sharedManager;

@end

@protocol CCBContextEventmanagerDelegate <NSObject>

@optional
- (void)willPostEvent:(NSDictionary *)event;
- (void)contextEventMangaer:(CCBContextEventManager *)eventManager willPostEvent:(NSDictionary *)event;

- (void)didPostEvent:(NSDictionary *)event;
- (void)contextEventMangaer:(CCBContextEventManager *)eventManager didPostEvent:(NSDictionary *)event;

@end

@protocol CCBContextEventmanagerDataSource <NSObject>

@optional
- (NSDictionary *)payloadForEvent:(NSDictionary *)event;
- (NSDictionary *)contextEventMangaer:(CCBContextEventManager *)eventManager payloadForEvent:(NSDictionary *)event;

@end


@interface CCBContextEventManager ()

@property id<CCBContextEventmanagerDelegate> delegate;
@property id<CCBContextEventmanagerDataSource> dataSource;

@end
