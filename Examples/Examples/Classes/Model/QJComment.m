//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJComment.h"
#import "QJUserInfo.h"


@implementation QJComment

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:
      @{
          @"content" : @"content",
          @"parent" : @"parent",
          @"userInfo" : @"user_info",
          @"createdAt" : @"created_at",
      }];
}

+ (NSValueTransformer *)userInfoJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[QJUserInfo class]];
}

+ (NSValueTransformer *)parentJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[QJComment class]];
}

@end