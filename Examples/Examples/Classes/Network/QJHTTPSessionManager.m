//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJHTTPSessionManager.h"

@implementation QJHTTPSessionManager

+ (QJHTTPSessionManager *)defaultSessionManager {
//  static MMHTTPSessionManager *_sharedInstance;
//  static dispatch_once_t onceToken;
//  dispatch_once(&onceToken, ^{
//    _sharedInstance = [MMHTTPSessionManager new];
//  });
  QJHTTPSessionManager *sharedInstance = [[QJHTTPSessionManager alloc] init];
  return sharedInstance;
}

@end