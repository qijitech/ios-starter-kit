//
//  SKManagedHTTPSessionManager+Network.h
//  Examples
//
//  Created by Hammer on 1/22/16.
//  Copyright © 2016 奇迹空间. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StarterKit/SKManagedHTTPSessionManager.h>
#import <Overcoat/OVCHTTPSessionManager+PromiseKit.h>

@interface SKManagedHTTPSessionManager (Example)

- (AnyPromise *)fetchFeeds:(NSDictionary *)parameters;
- (AnyPromise *)fetchFeedsWithId:(NSDictionary *)parameters;

@end
