//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKFetchedKeyTableViewController.h"
#import "SKTableViewControllerBuilder.h"
#import "SKKeyPaginator.h"

@implementation SKFetchedKeyTableViewController

- (void)createWithBuilder:(SKTableViewControllerBuilderBlock)block {
  NSParameterAssert(block);
  SKTableViewControllerBuilder *builder = [[SKTableViewControllerBuilder alloc] init];
  builder.paginator = [[SKKeyPaginator alloc] init];
  builder.canRefresh = YES;
  builder.canLoadMore = YES;
  block(builder);
  [super initWithBuilder:builder];
}

@end