//
//  AnyPromise+SKAnyPromise.m
//  Pods
//
//  Created by shuu on 2017/3/28.
//
//

#import "AnyPromise+SKAnyPromise.h"

extern dispatch_queue_t PMKDefaultDispatchQueue();

@implementation AnyPromise (SKAnyPromise)

- (AnyPromise *(^)(dispatch_block_t))finally {
  NSAssert(nil, @"Use always, please");
  
  return nil;
}

@end
