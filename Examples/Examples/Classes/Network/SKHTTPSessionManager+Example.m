//
//  SKHTTPSessionManager+Auth.m
//  Examples
//
//  Created by Hammer on 1/31/16.
//  Copyright © 2016 奇迹空间. All rights reserved.
//

#import "SKHTTPSessionManager+Example.h"
#import "User.h"
#import "Feed.h"

@implementation SKHTTPSessionManager (Example)

- (AnyPromise *)register:(NSDictionary *)parameters {
  return [self pmk_POST:@"/auth/register" parameters:parameters];
}

- (AnyPromise *)login:(NSDictionary *)parameters {
  return [self pmk_POST:@"/auth/login" parameters:parameters];
}

- (AnyPromise *)fetchFeeds:(NSDictionary *)parameters {
  return [self pmk_GET:@"/feedsWithPage" parameters:parameters];
}

- (AnyPromise *)fetchFeedsWithId:(NSDictionary *)parameters {
  return [self pmk_GET:@"/feeds" parameters:parameters];
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
