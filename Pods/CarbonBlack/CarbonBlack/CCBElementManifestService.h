//
//  CCBContextManifest.h
//  CarbonBlack
//
//  Created by Kevin Lee on 10/23/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCBManifestProxy.h"
#import "CCBElementServiceLocator.h"
#import "CCBContextEventManager.h"

/** This service queries the Carbon API for the contextual elements that have been configured for the application. 
 This is the entrypoint for discovering services that are used for the application.  The role of this class is find and broadcast the contextual elements that are needed to make contextual rules.*/
@interface CCBElementManifestService : NSObject

/** 
 returns the static instance of the service.
 */

+ (CCBElementManifestService *)sharedService;

/** 
 Qureies the element manifest and posts a notfication for each of the elements that are returned from the api.  The notifications names are contstructed using the following 
 patter: <element>_required_notification
 
 So if the location element is returned in the manifest, a location_required_notification will be posted to the default notification center.
 */
- (void)getManifest;

@end
