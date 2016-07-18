//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJNetworkClient.h"
#import "QJPost.h"

@implementation SKHTTPSessionManager (NetworkClient)

- (AnyPromise *)fetchFeeds:(NSDictionary *)parameters {
  return [self pmk_GET:@"/posts" parameters:parameters];
}

+ (NSDictionary *)modelClassesByResourcePath {
  return @{
      @"/posts" : [QJPost class],
  };
}

@end