//
// Created by Hammer on 1/31/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKAccountModel.h"

@implementation SKAccountModel

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
      @"identifier" : @"id",
      @"token" : @"token"
  };
}

// 针对特定的属性进行转换
+ (NSValueTransformer *)identifierJSONTransformer {
  return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *identifier) {
    return [identifier stringValue];
  } reverseBlock:^id(NSString *identifier) {
    return @[identifier];
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

- (NSString *)identifier {
  return _identifier;
}

- (NSString *)paginatorKey {
  return _identifier;
}

@end
