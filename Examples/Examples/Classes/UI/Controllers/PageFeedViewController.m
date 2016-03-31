//
// Created by Hammer on 1/23/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "PageFeedViewController.h"
#import <StarterKit/SKTableViewControllerBuilder.h>
#import "Feed.h"
#import "SKHTTPSessionManager+Example.h"
#import "SKFeedTableViewCell.h"
#import "SKFeedPictureTableViewCell.h"
#import <libextobjc/EXTScope.h>

@implementation PageFeedViewController

- (id)init {
  if (self = [super init]) {
    [self createWithBuilder:^(SKTableViewControllerBuilder *builder) {
      builder.cellMetadata = @[[SKFeedTableViewCell class], [SKFeedPictureTableViewCell class]];
      builder.entityName = @"Feed";
      builder.modelOfClass = [Feed class];

      @weakify(self);
      builder.paginateBlock = ^(NSDictionary *parameters) {
        @strongify(self)
        return [self.httpSessionManager fetchFeeds:parameters];
      };
    }];
  }
  return self;
}

- (NSString *)cellReuseIdentifier:(Feed *)item indexPath:(NSIndexPath *)indexPath {
  if (item.images && item.images.count > 0) {
    return [SKFeedPictureTableViewCell cellIdentifier];
  }
  return [SKFeedTableViewCell cellIdentifier];
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}
@end