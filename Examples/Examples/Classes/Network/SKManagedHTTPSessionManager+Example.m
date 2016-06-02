//
//  SKManagedHTTPSessionManager+Network.m
//  Examples
//
//  Created by Hammer on 1/22/16.
//  Copyright © 2016 奇迹空间. All rights reserved.
//

#import "SKManagedHTTPSessionManager+Example.h"
#import "Feed.h"

@implementation SKManagedHTTPSessionManager (Example)

- (AnyPromise *)fetchFeeds:(NSDictionary *)parameters {
  return [self pmk_GET:@"/feedsWithPage" parameters:parameters];
}

- (AnyPromise *)fetchFeedsWithId:(NSDictionary *)parameters {
  return [self pmk_GET:@"/feeds" parameters:parameters];
}

#pragma mark - OVCHTTPSessionManager

+ (NSDictionary *)modelClassesByResourcePath {
  return @{
    @"feeds" : [Feed class],
    @"feedsWithPage" : [Feed class],
  };
}
@end
