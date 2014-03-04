//
//  CCBManifestProxy.h
//  ContextHub
//
//  Created by Kevin Lee on 10/23/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCHHTTPSessionClient.h"

/** 
 Low-level proxy for retrieving the Element Manifest from the ContextHub contextual service API
 */
@interface CCHManifestProxy : NSObject

/** 
 Wraps a GET call to the ContextHub manifest api.  This method queries the api for all elementes that are configured for the app.
 @param success executed when the network request completes successfully.  The success param is passed the JSON that is received from the ContextHub API.
 @param failure executed when the network request fails.  The session and error are passed to the failure block.
 */
+ (void)getManifestWithSuccess:(void(^)(id responseObject))success
                       failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
