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

- (NSString *)paramSinceId {
  if (!_paramSinceId) {
    _paramSinceId = @"since_id";
  }
  return _paramSinceId;
}

- (NSString *)paramMaxId {
  if (!_paramMaxId) {
    _paramMaxId = @"max_id";
  }
  return _paramMaxId;
}

- (NSString *)paramPageSize {
  if (!_paramPageSize) {
    _paramPageSize = @"page_size";
  }
  return _paramPageSize;
}

- (NSString *)paramPage {
  if (!_paramPage) {
    _paramPage = @"page";
  }
  return _paramPage;
}

@end