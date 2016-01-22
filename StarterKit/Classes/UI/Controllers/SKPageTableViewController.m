//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKPageTableViewController.h"
#import "SKTableViewControllerBuilder.h"


@implementation SKPageTableViewController

+ (id)createWithBuilder:(SKTableViewControllerBuilderBlock)block {
  NSParameterAssert(block);
  SKTableViewControllerBuilder *builder = [[SKTableViewControllerBuilder alloc] init];
  builder.paginator = [[SKPagedPaginator alloc] init];
  block(builder);
  return [builder build];
}

@end