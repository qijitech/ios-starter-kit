//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJUser.h"
#import "QJUserInfo.h"
#import "QJUserToken.h"

@implementation QJUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:
      @{
          @"mobile" : @"mobile",
          @"email" : @"email",
          @"platform" : @"user_token",
          @"userInfo" : @"user_info",
      }];
}

+ (NSValueTransformer *)platformJSONTransformer {
  return [MTLJSONAdapter arrayTransformerWithModelClass:[QJUserToken class]];
}

+ (NSValueTransformer *)userInfoJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[QJUserInfo class]];
}

#pragma mark - NSCoding support

- (void)encodeWithCoder:(NSCoder *)encoder {
  [super encodeWithCoder:encoder];
  [encoder encodeObject:self.email forKey:@"email"];
  [encoder encodeObject:self.mobile forKey:@"mobile"];
  [encoder encodeObject:self.userToken forKey:@"user_token"];
  [encoder encodeObject:self.userInfo forKey:@"user_info"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
  if (self = [super initWithCoder:decoder]) {
    self.email = [decoder decodeObjectForKey:@"email"];
    self.mobile = [decoder decodeObjectForKey:@"mobile"];
    self.userToken = [decoder decodeObjectForKey:@"user_token"];
    self.userInfo = [decoder decodeObjectForKey:@"user_info"];
  }
  return self;
}

@end