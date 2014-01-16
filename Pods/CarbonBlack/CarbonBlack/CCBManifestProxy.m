//
//  CCBManifestProxy.m
//  CarbonBlack
//
//  Created by Kevin Lee on 10/23/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCBManifestProxy.h"

#define kManifestPath @"manifest"

@implementation CCBManifestProxy
+ (void)getManifestWithSuccess:(void(^)(id responseObject))success
                       failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    CCBHTTPClient *client = [CCBHTTPClient sharedClient];
    
    [client GET:kManifestPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
}


@end
