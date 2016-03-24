//
// Created by 杨玉刚 on 3/24/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "FetchedKeyFeedViewController.h"

#import <StarterKit/SKTableViewControllerBuilder.h>
#import <libextobjc/EXTScope.h>
#import "SKFeedTableViewCell.h"
#import "Feed.h"
#import "SKFeedPictureTableViewCell.h"
#import "SKManagedHTTPSessionManager+Example.h"

@implementation FetchedKeyFeedViewController

- (id)init {
  if (self = [super init]) {
    [self createWithBuilder:^(SKTableViewControllerBuilder *builder) {
      builder.cellMetadata = @[[SKFeedTableViewCell class], [SKFeedPictureTableViewCell class]];
      builder.entityName = @"Feed";
      builder.modelOfClass = [Feed class];

      builder.dequeueReusableCellBlock = ^NSString *(Feed *item, NSIndexPath *indexPath) {
        if (item.images && item.images.count > 0) {
          return [SKFeedPictureTableViewCell cellIdentifier];
        }
        return [SKFeedTableViewCell cellIdentifier];
      };

      @weakify(self);
      builder.paginateBlock = ^(NSDictionary *parameters) {
        @strongify(self)
        return [self.httpSessionManager fetchFeedsWithId:parameters];
      };
    }];
  }
  return self;
}

@end