//
//  CCBVaultProxy.m
//  ContextHub
//
//  Created by Kevin Lee on 10/8/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCHVaultProxy.h"

@implementation CCHVaultProxy

+ (CCHVaultProxy *)sharedProxy {
    static CCHVaultProxy *__shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shared = [[CCHVaultProxy alloc] init];
    });
    return __shared;
}

- (void)createItem:(NSDictionary *)item
     inContainer:(NSString *)containerName
         success:(void(^)(id responseObject))success
         failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {

    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    
    NSDictionary *paramData = @{@"data":item};
    NSString *path = [NSString stringWithFormat:@"vault/data/%@.json",containerName];
    [client POST:path parameters:paramData success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
}


- (void)getItemsInContainer:(NSString *)containerName
                    success:(void(^)(id responseObject))success
                    failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {

    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    NSString *path = [NSString stringWithFormat:@"vault/data/%@.json",containerName];
    [client GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
}


- (void)getItemWithId:(NSString *)vaultId inContainer:(NSString *)containerName
                    success:(void(^)(id responseObject))success
                    failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    NSString *path = [NSString stringWithFormat:@"vault/data/%@/%@",containerName, vaultId];
    [client GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
}

- (void)deleteItemWithId:(NSString *)vaultId inContainer:(NSString *)containerName
              success:(void(^)(id responseObject))success
              failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:@"vault/data/%@/%@",containerName, vaultId];
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    [client DELETE:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
}

- (void)putItem:(NSDictionary *)item inContainer:(NSString *)containerName
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSDictionary *paramData = @{@"data":item};
    NSString *vault_id = [item valueForKeyPath:@"vault_info.id"];
    NSString *path = [NSString stringWithFormat:@"vault/data/%@/%@", containerName, vault_id];
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    [client PUT:path parameters:paramData success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:failure];
}

- (void)createItem:(NSDictionary *)item
     withResources:(NSArray *)resources
       inContainer:(NSString *)containerName
           success:(void(^)(id responseObject))success
           failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    
    NSDictionary *params = @{@"data":item};
    NSString *path = [NSString stringWithFormat:@"vault/data/%@.json",containerName];
    
    [client POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (CCHVaultResource *resource in resources) {
            NSString *wrappedName =  [NSString stringWithFormat:@"data[%@]", resource.name];
            [formData appendPartWithFileData:resource.data name:wrappedName fileName:resource.fileName mimeType:resource.mimeType];
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
         success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
         failure(task, error);
        }
    }];

}

- (void)putItem:(NSDictionary *)item
  withResources:(NSArray *)resources
    inContainer:(NSString *)containerName
        success:(void(^)(id responseObject))success
        failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    CCHHTTPSessionClient *client = [CCHHTTPSessionClient sharedClient];
    
    NSDictionary *paramData = @{@"data":item};
    NSString *vault_id = [item valueForKeyPath:@"vault_info.id"];
    NSString *path = [NSString stringWithFormat:@"vault/data/%@/%@", containerName, vault_id];
    
    [client PUT:path parameters:paramData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (CCHVaultResource *resource in resources) {
            NSString *wrappedName =  [NSString stringWithFormat:@"data[%@]", resource.name];
            [formData appendPartWithFileData:resource.data name:wrappedName fileName:resource.fileName mimeType:resource.mimeType];
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
    
}
@end
