//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJPost.h"
#import "QJUserInfo.h"
#import "QJImage.h"
#import "QJCategory.h"

@implementation QJPost

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:
      @{
          @"content" : @"content",
          @"countViews" : @"count_views",
          @"countComments" : @"count_comments",
          @"createdAt" : @"created_at",
          @"userInfo" : @"user_info",
          @"category" : @"category",
          @"images" : @"images",
          @"lng" : @"lng",
          @"lat" : @"lat",
      }];
}

+ (NSValueTransformer *)userInfoJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[QJUserInfo class]];
}

+ (NSValueTransformer *)imagesJSONTransformer {
  return [MTLJSONAdapter arrayTransformerWithModelClass:[QJImage class]];
}

+ (NSValueTransformer *)categoryJSONTransformer {
  return [MTLJSONAdapter dictionaryTransformerWithModelClass:[QJCategory class]];
}

- (NSArray *)buildPhotoArray:(NSUInteger)width height:(NSUInteger)height {
  if (self.images && self.images.count > 0) {
    NSMutableArray *imageUrls = [NSMutableArray new];
    [self.images enumerateObjectsUsingBlock:^(QJImage *image, NSUInteger idx, BOOL *stop) {
      imageUrls[idx] = [image toURL:width height:height];
    }];
    return [imageUrls copy];
  }
  return @[];
}

@end