//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJUserToken.h"


@implementation QJUserToken

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:
      @{
          @"openId" : @"open_id",
          @"platform" : @"platform",
          @"isBind" : @"is_bind",
          @"userId" : @"user_id",

      }];
}

#pragma mark - NSCoding support

- (void)encodeWithCoder:(NSCoder *)encoder {
  [super encodeWithCoder:encoder];
  [encoder encodeObject:self.openId forKey:@"open_id"];
  [encoder encodeObject:self.userId forKey:@"user_id"];
  [encoder encodeInteger:self.platform forKey:@"platform"];
  [encoder encodeBool:self.isBind forKey:@"is_bind"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
  if (self = [super initWithCoder:decoder]) {
    self.openId = [decoder decodeObjectForKey:@"open_id"];
    self.userId = [decoder decodeObjectForKey:@"user_id"];
    self.platform = [decoder decodeIntegerForKey:@"platform"];
    self.isBind = [decoder decodeBoolForKey:@"is_bind"];
  }
  return self;
}

@end