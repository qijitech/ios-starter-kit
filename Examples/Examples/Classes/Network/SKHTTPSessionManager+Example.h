//
//  SKHTTPSessionManager+Auth.h
//  Examples
//
//  Created by Hammer on 1/31/16.
//  Copyright © 2016 奇迹空间. All rights reserved.
//

#import <StarterKit/SKHTTPSessionManager.h>

@interface SKHTTPSessionManager (Example)

- (AnyPromise *)register:(NSDictionary *)parameters;

- (AnyPromise *)login:(NSDictionary *)parameters;

- (AnyPromise *)fetchFeeds:(NSDictionary *)parameters;
- (AnyPromise *)fetchFeedsWithId:(NSDictionary *)parameters;

@end
