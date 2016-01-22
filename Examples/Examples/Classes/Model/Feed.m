//
// Created by Hammer on 1/22/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "Feed.h"
#import "User.h"
#import "Image.h"

@implementation Feed

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
      @"content" : @"content",
      @"shareTimes" : @"share_times",
      @"browseTimes" : @"browse_times",
      @"commentTimes" : @"comment_times",
      @"createdAt" : @"created_at",
      @"user" : @"user",
      @"images" : @"images",
  }];
}

+ (NSValueTransformer *)userJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[User class]];
}

+ (NSValueTransformer *)imagesJSONTransformer {
  return [MTLJSONAdapter arrayTransformerWithModelClass:[Image class]];
}

#pragma mark MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
  return @"Feed";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
  return [NSDictionary mtl_identityPropertyMapWithModel:self];
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
  return [NSSet setWithObject:@"identifier"];
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey {
  return @{
      @"user" : [User class],
      @"images" : [Image class],
  };
}

@end