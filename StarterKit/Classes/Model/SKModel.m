//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKModel.h"


@implementation SKModel

#pragma mark MTLManagedObjectSerializing

// The name of the Core Data entity that the receiver serializes to and
// deserializes from.
//
// This method must not return nil.
+ (NSString *)managedObjectEntityName {
    return nil;
}

// Specifies how to map property keys to different keys on the receiver's
// +managedObjectEntity.
//
// Entity attributes will be mapped to and from the receiver's properties using
// +entityAttributeTransformerForKey:. Entity relationships will be mapped to
// and from MTLModel objects using +relationshipModelClassesByPropertyKey.
// Fetched properties are not supported.
//
// Subclasses overriding this method should combine their values with those of
// `super`.
//
// Any keys omitted will not participate in managed object serialization.
//
// Returns a dictionary mapping property keys to entity keys (as strings) or
// NSNull values.
+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return nil;
}

@end