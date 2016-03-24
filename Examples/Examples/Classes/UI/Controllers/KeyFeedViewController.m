//
// Created by Hammer on 1/22/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <StarterKit/SKTableViewControllerBuilder.h>
#import <libextobjc/EXTScope.h>
#import <StarterKit/SKLoadMoreTableViewCell.h>
#import "KeyFeedViewController.h"
#import "SKFeedTableViewCell.h"
#import "Feed.h"
#import "SKFeedPictureTableViewCell.h"
#import "SKManagedHTTPSessionManager+Network.h"

@interface KeyFeedViewController ()

@end

@implementation KeyFeedViewController

- (id)init {
  if (self = [super init]) {
    [self createWithBuilder:^(SKTableViewControllerBuilder *builder) {
      builder.cellMetadata = @[[SKFeedTableViewCell class], [SKFeedPictureTableViewCell class]];
      builder.entityName = @"Feed";
      builder.modelOfClass = [Feed class];
      @weakify(self);
      builder.dequeueReusableCellBlock = ^NSString *(Feed *item, NSIndexPath *indexPath) {
        if (item.images && item.images.count > 0) {
          return [SKFeedPictureTableViewCell cellIdentifier];
        }
        return [SKFeedTableViewCell cellIdentifier];
      };

      builder.paginateBlock = ^(NSDictionary *parameters) {
        @strongify(self)
        return [self.httpSessionManager fetchFeedsWithId:parameters];
      };

    }];
  }
  return self;
}

@end