//
// Created by Hammer on 1/22/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <PromiseKit/Umbrella.h>
#import <Overcoat/OVCHTTPSessionManager+PromiseKit.h>
#import "Network.h"
#import "Feed.h"


@implementation Network

- (AnyPromise *)fetchFeeds:(NSDictionary *)parameters {
  return [self GET:@"/feedsWithPage" parameters:parameters];
}

- (AnyPromise *)fetchFeedsWithId:(NSDictionary *)parameters {
  return [self GET:@"/feeds" parameters:parameters];
}

#pragma mark - OVCHTTPSessionManager

+ (NSDictionary *)modelClassesByResourcePath {
  return @{
      @"feeds" : [Feed class],
  };
}

@end