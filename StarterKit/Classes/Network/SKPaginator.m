//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Overcoat/OVCResponse.h>
#import <libextobjc/EXTScope.h>
#import "SKPaginator.h"
#import "SKNetworkConfig.h"

@interface SKPaginator ()
@property(nonatomic, assign) NSUInteger pageSize;
@property(nonatomic, copy) NSString *paramPageSize;
@property(nonatomic, copy) NSString *paramMaxId;
@property(nonatomic, copy) NSString *paramSinceId;
@property(nonatomic, copy) NSString *paramPage;
@end

@implementation SKPaginator

- (instancetype)init {
  if (self = [super init]) {
    _pageSize = [SKNetworkConfig sharedInstance].perPage;
    _paramPage = [SKNetworkConfig sharedInstance].paramPage;
    _paramPageSize = [SKNetworkConfig sharedInstance].paramPageSize;
    _paramSinceId = [SKNetworkConfig sharedInstance].paramSinceId;
    _paramMaxId = [SKNetworkConfig sharedInstance].paramMaxId;
    self.hasMorePages = YES;
  }
  return self;
}

- (void)setLoading:(BOOL)loading {
  if (self.isLoading == loading) {
    return;
  }
  _loading = loading;
}

- (void)setRefresh:(BOOL)refresh {
  if (self.isRefresh == refresh) {
    return;
  }
  _refresh = refresh;
}

- (AnyPromise *)refresh {
  return nil;
}

- (AnyPromise *)loadMore {
  return nil;
}

@end
