//
// Created by Hammer on 1/31/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKAccountModel.h"

@implementation SKAccountModel

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
      @"token" : @"token"
  }];
}

#pragma mark - NSCoding support

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:self.identifier forKey:@"identifier"];
  [encoder encodeObject:self.token forKey:@"token"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
  self.identifier = [decoder decodeObjectForKey:@"identifier"];
  self.token = [decoder decodeObjectForKey:@"token"];
  return self;
}

@end