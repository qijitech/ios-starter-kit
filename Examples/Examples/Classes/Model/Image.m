//
// Created by Hammer on 1/22/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "Image.h"


@implementation Image

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
      @"type" : @"type",
      @"url" : @"url",
  }];
}

+ (NSValueTransformer *)avatarJSONTransformer {
  return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
  return @"Image";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
//  return [NSDictionary mtl_identityPropertyMapWithModel:self];
  return @{
      @"identifier" : @"identifier",
      @"type" : @"type",
  };

}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
  return [NSSet setWithObject:@"identifier"];
}

@end