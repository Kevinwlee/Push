//
//  CCBEventProxy.m
//  ContextHub
//
//  Created by Kevin Lee on 10/25/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCHEventProxy.h"

@implementation CCHEventProxy

+ (void)postEventPackage:(NSDictionary *)event
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    
    [client POST:@"events" parameters:event success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
    
}

@end
