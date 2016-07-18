//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <StarterKit/SKTableViewControllerBuilder.h>
#import <libextobjc/EXTScope.h>
#import "QJFeedsViewController.h"
#import "QJFeedUserView.h"
#import "QJFeedsTableViewCell.h"
#import "QJPost.h"
#import "QJNetworkClient.h"

@interface QJFeedsViewController () <QJFeedUserViewDelegate>
@property(nonatomic) BOOL isRefreshed;
@end

@implementation QJFeedsViewController

- (id)init {
  if (self = [super init]) {
    [self createWithBuilder:^(SKTableViewControllerBuilder *builder) {
      builder.cellMetadata = @[[QJFeedsTableViewCell class]];
      builder.modelOfClass = [QJPost class];

      @weakify(self);
      builder.paginateBlock = ^(NSDictionary *parameters) {
        @strongify(self)
        NSMutableDictionary *params = [parameters mutableCopy];
        params[@"lat"] = @(1);
        params[@"lng"] = @(1);
        return [self.httpSessionManager fetchFeeds:[params copy]];
      };
    }];
  }
  return self;
}

- (BOOL)configureCell:(QJFeedsTableViewCell *)cell withItem:(id)item {
  cell.delegate = self;
  return NO;
}

- (void)didAvatarTapped:(QJUserInfo *)userInfo {
}

@end