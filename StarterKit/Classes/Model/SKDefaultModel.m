//
// Created by Hammer on 12/3/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKDefaultModel.h"

@implementation SKDefaultModel

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
      @"identifier" : @"id",
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

- (NSString *)identifier {
  return _identifier;
}

- (NSString *)paginatorKey {
  return _identifier;
}
@end
