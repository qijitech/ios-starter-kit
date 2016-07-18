//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJImage.h"
#import "QJConfig.h"

@implementation QJImage

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:
      @{
          @"url" : @"url"
      }];
}

- (NSURL *)toURL:(NSInteger)width height:(NSInteger)height {
  if ([_url hasPrefix:@"http"]) {
    return [NSURL URLWithString:_url];
  }
  NSString *fullUrl = [NSString stringWithFormat:@"%@%@?imageView2/1/w/%ld/h/%ld", kQiNiuBaseURL, _url, width, height];
  return [NSURL URLWithString:fullUrl];
}

@end