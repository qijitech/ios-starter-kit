//
//  QJPaginatorPost.m
//  Examples
//
//  Created by shuu on 2016/12/7.
//  Copyright © 2016年 奇迹空间. All rights reserved.
//

#import "QJPaginatorPost.h"
#import "QJPost.h"

@implementation QJPaginatorPost

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:
          @{
            @"data" : @"data",
            }];
}


+ (NSValueTransformer *)dataJSONTransformer {
  return [MTLJSONAdapter arrayTransformerWithModelClass:[QJPost class]];
}

@end
