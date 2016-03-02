//
// Created by Hammer on 1/22/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "Image.h"


@implementation Image

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
      @"url" : @"url",
      @"width" : @"width",
      @"height" : @"height",
  }];
}

+ (NSValueTransformer *)urlJSONTransformer {
  return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
  return @"Image";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
  return [NSDictionary mtl_identityPropertyMapWithModel:self];
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
  return [NSSet setWithObject:@"identifier"];
}

@end