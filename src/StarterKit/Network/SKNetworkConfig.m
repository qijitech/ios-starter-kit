//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKNetworkConfig.h"


static NSUInteger const kPaginatorPerPage = 20;

@implementation SKNetworkConfig

+ (SKNetworkConfig *)sharedInstance {
  static id sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (NSUInteger)perPage {
  return _perPage <= 0 ? kPaginatorPerPage : _perPage;
}

@end