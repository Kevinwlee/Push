//
//  CCBManifestProxy.h
//  CarbonBlack
//
//  Created by Kevin Lee on 10/23/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCBHTTPClient.h"

/** 
 Low-level proxy for retrieving the Element Manifest from the Carbon contextual service API
 */
@interface CCBManifestProxy : NSObject

/** 
 Wraps a GET call to the Carbon manifest api.  This method queries the api for all elementes that are configured for the app.
 @param success executed when the network request completes successfully.  The success param is passed the JSON that is received from the carbon API.
 @param failure executed when the network request fails.  The session and error are passed to the failure block.
 */
+ (void)getManifestWithSuccess:(void(^)(id responseObject))success
                       failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
