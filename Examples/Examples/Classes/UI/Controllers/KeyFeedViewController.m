//
// Created by Hammer on 1/22/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <StarterKit/SKTableViewControllerBuilder.h>
#import "KeyFeedViewController.h"
#import "Feed.h"
#import "SKManagedHTTPSessionManager+Network.h"
#import "SKFeedTableViewCell.h"
#import "SKFeedPictureTableViewCell.h"
#import <libextobjc/EXTScope.h>

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
      builder.paginateBlock = ^(NSDictionary *parameters) {
        @strongify(self)
        return [self.httpSessionManager fetchFeedsWithId:parameters];
      };
    }];
  }
  return self;
}

- (NSString *)cellIdentifier:(Feed *)data {
  if (data.images && data.images.count > 0) {
    return [SKFeedPictureTableViewCell cellIdentifier];
  }
  return [SKFeedTableViewCell cellIdentifier];
}

@end