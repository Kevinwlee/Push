//
//  CCBVaultProxy.h
//  CarbonBlack
//
//  Created by Kevin Lee on 10/8/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCBHTTPClient.h"
#import "CCBVaultResource.h"
/**
 The CCBVaultProxy is a low level api for persiting data in the Carbon Vault.
 
 */

@interface CCBVaultProxy : NSObject
/**
 The shared CCBVaultProxy is a low level api for persiting data in the Carbon Vault.
 
 @returns the static shared instance of the the Vault Proxy
 */

+ (CCBVaultProxy *)sharedProxy;

/** 
 Posts an item to the v1/vault/data/ endpoint
 @param item dictionary containing the data that is to be saved.
 @param containerName name of the container
 @param success executed when the HTTP response completes without errors
 @param failure executed if the HTTP requst returns an error
 */
- (void)createItem:(NSDictionary *)item
     inContainer:(NSString *)containerName
         success:(void(^)(id responseObject))success
         failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
Posts a mulitpart form request with the data AND resources.
 @param item the NSDictionary representation of the item you want to persist.
 @param resources an array CCBVaultResource for the files that you want to upload.
 @param containerName the name of the container that will be used to store similar data.
 @param success executed when the HTTP response completes without errors.
 @param failure executed if the HTTP request returns an error.
 */
- (void)createItem:(NSDictionary *)item
     withResources:(NSArray *)resources
       inContainer:(NSString *)containerName
           success:(void(^)(id responseObject))success
           failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 Gets all items in the container
 @param containerName name of the container
 @param success executed when the HTTP response completes without errors
 @param failure executed if the HTTP reqeust returns an error
 */
- (void)getItemsInContainer:(NSString *)containerName
                    success:(void(^)(id responseObject))success
                    failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 Gets a single item in the container
 @param vaultId the server id of the item
 @param containerName name of the container
 @param success executed when the HTTP response completes without errors
 @param failure executed if the HTTP requst returns an error
 */
- (void)getItemWithId:(NSString *)vaultId inContainer:(NSString *)containerName
              success:(void(^)(id responseObject))success
              failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 Deletes a single item in the container
 @param vaultId the server id of the item
 @param containerName name of the container
 @param success executed when the HTTP response completes without errors
 @param failure executed if the HTTP requst returns an error
 */

- (void)deleteItemWithId:(NSString *)vaultId inContainer:(NSString *)containerName
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 Updates an item in the container
 @param item the item that should be saved
 @param containerName name of the container
 @param success executed when the HTTP response completes without errors
 @param failure executed if the HTTP requst returns an error
 */
- (void)putItem:(NSDictionary *)item inContainer:(NSString *)containerName
        success:(void(^)(id responseObject))success
        failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 Updates an item in the container with file resources
 @param item the item that should be saved
 @param resources an array CCBVaultResource objects for the files that you want to upload.
 @param containerName name of the container
 @param success executed when the HTTP response completes without errors
 @param failure executed if the HTTP requst returns an error
 */
- (void)putItem:(NSDictionary *)item
  withResources:(NSArray *)resources
    inContainer:(NSString *)containerName
        success:(void(^)(id responseObject))success
        failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
