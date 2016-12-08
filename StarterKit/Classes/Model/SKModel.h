//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLManagedObjectAdapter/MTLManagedObjectAdapter.h>

@protocol SKModelIdentifier <NSObject>
- (NSString *)identifier;
- (NSString *)paginatorKey;
@end

@interface SKModel : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing, SKModelIdentifier>


@end