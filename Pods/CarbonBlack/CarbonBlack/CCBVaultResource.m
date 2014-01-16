//
//  CCBVaultResource.m
//  CarbonBlack
//
//  Created by Kevin Lee on 10/21/13.
//  Copyright (c) 2013 ChaiOne. All rights reserved.
//

#import "CCBVaultResource.h"

@implementation CCBVaultResource

- (id)initWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType data:(NSData *)data {
    self = [super init];
    if (self) {
        _name = name;
        _fileName = fileName;
        _mimeType = mimeType;
        _data = data;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name:%@,  fileName:%@, mimeType:%@", self.name, self.fileName, self.mimeType];
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.fileName forKey:@"fileName"];
    [aCoder encodeObject:self.mimeType forKey:@"mimeType"];
    [aCoder encodeObject:self.data forKey:@"data"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
        self.mimeType = [aDecoder decodeObjectForKey:@"mimeType"];
        self.data = [aDecoder decodeObjectForKey:@"data"];
    }
    return self;
}


@end
