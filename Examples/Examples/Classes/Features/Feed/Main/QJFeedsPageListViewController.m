//
//  QJFeedsPageListViewController.m
//  Examples
//
//  Created by shuu on 2017/4/10.
//  Copyright © 2017年 奇迹空间. All rights reserved.
//

#import <StarterKit/SKTableViewControllerBuilder.h>
#import "QJFeedsPageListViewController.h"
#import <libextobjc/EXTScope.h>
#import "QJNetworkClient.h"
#import "QJFeedsPageListTableViewCell.h"
#import "QJPageListModel.h"

@implementation QJFeedsPageListViewController

- (id)init {
  if (self = [super init]) {
    [self createWithBuilder:^(SKTableViewControllerBuilder *builder) {
      builder.cellMetadata = @[[QJFeedsPageListTableViewCell class]];
      builder.modelOfClass = [QJPageListModel class];
      builder.customPageName = @"customPageName";
      builder.customPageSize = @"customPageSize";
      @weakify(self);
      builder.paginateBlock = ^(NSDictionary *parameters) {
        @strongify(self)
        NSMutableDictionary *params = [parameters mutableCopy];
        params[@"lat"] = @(1);
        params[@"lng"] = @(1);
        return [self.httpSessionManager fetchFeedsWithPages:[params copy]];
      };
    }];
  }
  return self;
}

@end
