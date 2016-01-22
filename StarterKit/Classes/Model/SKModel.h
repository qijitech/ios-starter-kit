//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLManagedObjectAdapter/MTLManagedObjectAdapter.h>

@interface SKModel : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property(nonatomic, strong) NSNumber *identifier;

@end