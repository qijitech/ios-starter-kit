//
// Created by Hammer on 1/22/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "User.h"


@implementation User

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
      @"phone" : @"phone",
      @"nickname" : @"nickname",
      @"avatar" : @"avatar",
      @"realName" : @"real_name",
      @"sex" : @"sex",
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
  return [NSDictionary mtl_identityPropertyMapWithModel:self];
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
  return [NSSet setWithObject:@"identifier"];
}

#pragma mark - NSCoding support

- (void)encodeWithCoder:(NSCoder *)encoder {
  [super encodeWithCoder:encoder];
  [encoder encodeObject:self.nickname forKey:@"nickname"];
  [encoder encodeObject:self.avatar forKey:@"avatar"];
  [encoder encodeObject:self.realName forKey:@"realName"];
  [encoder encodeObject:self.sex forKey:@"sex"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
  if (self = [super initWithCoder:decoder]) {
    self.nickname = [decoder decodeObjectForKey:@"nickname"];
    self.avatar = [decoder decodeObjectForKey:@"avatar"];
    self.realName = [decoder decodeObjectForKey:@"realName"];
    self.sex = [decoder decodeObjectForKey:@"sex"];
  }
  return self;
}

@end