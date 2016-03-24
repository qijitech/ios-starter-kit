//
//  SKHTTPSessionManager+Auth.m
//  Examples
//
//  Created by Hammer on 1/31/16.
//  Copyright © 2016 奇迹空间. All rights reserved.
//

#import <Overcoat/OVCHTTPSessionManager+PromiseKit.h>
#import "SKHTTPSessionManager+Example.h"
#import "User.h"
#import "Feed.h"

@implementation SKHTTPSessionManager (Example)

- (AnyPromise *)register:(NSDictionary *)parameters {
  return [self POST:@"/auth/register" parameters:parameters];
}

- (AnyPromise *)login:(NSDictionary *)parameters {
  return [self POST:@"/auth/login" parameters:parameters];
}

- (AnyPromise *)fetchFeeds:(NSDictionary *)parameters {
  return [self GET:@"/feedsWithPage" parameters:parameters];
}

- (AnyPromise *)fetchFeedsWithId:(NSDictionary *)parameters {
  return [self GET:@"/feeds" parameters:parameters];
}

+ (NSDictionary *)modelClassesByResourcePath {
  return @{
      @"auth/register" : [User class],
      @"auth/login" : [User class],
      @"feeds" : [Feed class],
      @"feedsWithPage" : [Feed class],
  };
}

@end
