//
// Created by Hammer on 3/24/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKArrayDataSourceBuilder.h"
#import "SKArrayDataSource.h"


@implementation SKArrayDataSourceBuilder

- (SKArrayDataSource *)build {
  return [[SKArrayDataSource alloc] initWithBuilder:self];
}
@end