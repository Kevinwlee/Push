//
//  CCBManifestProxy.m
//  ContextHub
//
//  Created by Kevin Lee on 10/23/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCHManifestProxy.h"

#define kManifestPath @"manifest"

@implementation CCHManifestProxy
+ (void)getManifestWithSuccess:(void(^)(id responseObject))success
                       failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    
    [client GET:kManifestPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
}


@end
