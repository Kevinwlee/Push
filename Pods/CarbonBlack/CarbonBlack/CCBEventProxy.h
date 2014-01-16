//
//  CCBEventProxy.h
//  CarbonBlack
//
//  Created by Kevin Lee on 10/25/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCBHTTPClient.h"

/** 
 Low-level proxy for posting Event Packages to Carbon contextual service API
 */
@interface CCBEventProxy : NSObject

/** 
 Wraps the events api
 @param event the event package that will be posted to the context api.  This event package is defined by the Carbon API
 @param success executed when the network request completes successfully.  The success param is passed the JSON that is received from the carbon API.
 @param failure executed when the network request fails.  The session and error are passed to the failure block.
 */
+ (void)postEventPackage:(NSDictionary *)event
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;


@end
