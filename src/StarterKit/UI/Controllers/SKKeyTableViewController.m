//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKKeyTableViewController.h"
#import "SKTableViewControllerBuilder.h"


@implementation SKKeyTableViewController

+ (instancetype)createWithBuilder:(SKTableViewControllerBuilderBlock)block {
  NSParameterAssert(block);
  SKTableViewControllerBuilder *builder = [[SKTableViewControllerBuilder alloc] init];
  builder.paginator = [[SKKeyPaginator alloc] init];
  block(builder);
  return [builder build];
}

@end