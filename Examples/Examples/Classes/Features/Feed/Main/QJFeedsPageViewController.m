//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <StarterKit/SKTableViewControllerBuilder.h>
#import <libextobjc/EXTScope.h>
#import <StarterKit/SKAccountManager.h>
#import "QJFeedsPageViewController.h"
#import "QJFeedUserView.h"
#import "QJFeedsTableViewCell.h"
#import "QJPost.h"
#import "QJPaginatorPost.h"
#import "QJNetworkClient.h"
#import "NavUtils.h"

@interface QJFeedsPageViewController () <QJFeedUserViewDelegate>
@property(nonatomic) BOOL isRefreshed;
@end

@implementation QJFeedsPageViewController

- (id)init {
  if (self = [super init]) {
    [self createWithBuilder:^(SKTableViewControllerBuilder *builder) {
      builder.cellMetadata = @[[QJFeedsTableViewCell class]];
      builder.modelOfClass = [QJPost class];
      builder.paginatorModelOfClass = [QJPaginatorPost class];
      builder.resultKeyValue = @"data";
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

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"ic_account"]
              style:UIBarButtonItemStyleDone target:self
             action:@selector(didAccountTapped)];
}

- (void)didAccountTapped {
  if (![SKAccountManager defaultAccountManager].isLoggedIn) {
    [NavUtils navLoginCtrl:self.navigationController];
  }
}

- (BOOL)configureCell:(QJFeedsTableViewCell *)cell withItem:(id)item {
  cell.delegate = self;
  return NO;
}

- (void)didAvatarTapped:(QJUserInfo *)userInfo {
  [self contractModel];
}

@end
