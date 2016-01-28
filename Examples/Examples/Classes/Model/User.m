//
// Created by Hammer on 1/22/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "User.h"


@implementation User

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
      @"phone" : @"phone",
      @"nickname" : @"nickname",
      @"avatar" : @"avatar",
      @"realName" : @"real_name",
      @"sex" : @"sex",
      @"token" : @"token"
  }];
}

+ (NSValueTransformer *)avatarJSONTransformer {
  return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
  return @"User";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
//    NSLog(@"^%@==========", [NSDictionary mtl_identityPropertyMapWithModel:self]);
    return [NSDictionary mtl_identityPropertyMapWithModel:self];
//  return @{
//      @"identifier" : @"identifier",
//      @"phone" : @"phone",
//      @"nickname" : @"nickname",
//      @"realName" : @"realName",
//      @"sex" : @"sex",
//      @"token" : @"token"
//  };
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
  return [NSSet setWithObject:@"identifier"];
}

@end