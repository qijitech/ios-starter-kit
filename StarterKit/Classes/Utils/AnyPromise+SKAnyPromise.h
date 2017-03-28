//
//  AnyPromise+SKAnyPromise.h
//  Pods
//
//  Created by shuu on 2017/3/28.
//
//

#import <PromiseKit/AnyPromise.h>

@interface AnyPromise (SKAnyPromise)

// Adapt to old project
- (AnyPromise * __nonnull(^ __nonnull)(dispatch_block_t __nonnull))finally __attribute__((deprecated("Use always")));

@end
