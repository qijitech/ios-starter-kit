//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKFetchedResultsDataSourceBuilder.h"
#import "SKFetchedResultsDataSource.h"

@implementation SKFetchedResultsDataSourceBuilder

- (SKFetchedResultsDataSource *)build {
  return [[SKFetchedResultsDataSource alloc] initWithBuilder:self];
}

@end