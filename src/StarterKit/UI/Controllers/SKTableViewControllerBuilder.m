//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKTableViewControllerBuilder.h"
#import "SKTableViewController.h"
#import "SKPaginator.h"
#import "SKManagedHTTPSessionManager.h"


@implementation SKTableViewControllerBuilder

- (SKTableViewController *)build {
  return [[SKTableViewController alloc] initWithBuilder:self];
}

@end