//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKFetchedPageTableViewController.h"
#import "SKTableViewControllerBuilder.h"
#import "SKPagedPaginator.h"

@implementation SKFetchedPageTableViewController

- (void)createWithBuilder:(SKTableViewControllerBuilderBlock)block {
  NSParameterAssert(block);
  SKTableViewControllerBuilder *builder = [[SKTableViewControllerBuilder alloc] init];
  builder.paginator = [[SKPagedPaginator alloc] init];
  builder.canRefresh = YES;
  builder.canLoadMore = YES;
  block(builder);
  [super initWithBuilder:builder];
}

@end