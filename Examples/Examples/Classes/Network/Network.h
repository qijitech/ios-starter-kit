//
// Created by Hammer on 1/22/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StarterKit/SKManagedHTTPSessionManager.h>

@class AnyPromise;


@interface Network : SKManagedHTTPSessionManager

- (AnyPromise *)fetchFeeds:(NSDictionary *)parameters;
- (AnyPromise *)fetchFeedsWithId:(NSDictionary *)parameters;

@end