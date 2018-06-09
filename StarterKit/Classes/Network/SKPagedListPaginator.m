//
//  SKPagedListPaginator.m
//  Pods
//
//  Created by shuu on 2017/4/10.
//
//

#import "SKPagedListPaginator.h"
#import <Overcoat/OVCResponse.h>
#import <libextobjc/EXTScope.h>

/////////////////////////////
/////////////////////////////
@interface SKPagedListPaginator ()
@property(nonatomic, assign) NSUInteger firstPage;
@property(nonatomic, assign) NSUInteger nextPage;

@property(nonatomic, copy) NSString *paramPageSize;
@property(nonatomic, copy) NSString *paramPage;

@end

@implementation SKPagedListPaginator

- (instancetype)init {
  if (self = [super init]) {
    _firstPage = 1;
    self.hasMorePages = YES;
  }
  return self;
}

- (AnyPromise *)refresh {
  if (self.refresh || self.loading) {
    return nil;
  }
  if (self.delegate && [self.delegate respondsToSelector:@selector(networkOnStart:)]) {
    self.refresh = YES;
    self.loading = YES;
    [self.delegate networkOnStart:YES];
  }
  if (self.delegate && [self.delegate respondsToSelector:@selector(paginate:)]) {
    NSDictionary *parameters = @{self.paramPage : @(self.firstPage), self.paramPageSize : @(self.pageSize)};
    return [self paginate:parameters isRefresh:YES];
  }

  return nil;
}

- (AnyPromise *)loadMore {
  if (self.refresh || self.loading) {
    return nil;
  }
  if (self.delegate && [self.delegate respondsToSelector:@selector(networkOnStart:)]) {
    self.refresh = NO;
    self.loading = YES;
    [self.delegate networkOnStart:NO];
  }
  if (self.delegate && [self.delegate respondsToSelector:@selector(paginate:)]) {
    NSDictionary *parameters = @{self.paramPage : @(self.nextPage), self.paramPageSize : @(self.pageSize)};
    return [self paginate:parameters isRefresh:NO];
  }

  return nil;
}

- (AnyPromise *)paginate:(NSDictionary *)parameters isRefresh:(BOOL)isRefresh {
  if (!self.delegate || ![self.delegate respondsToSelector:@selector(paginate:)]) {
    return nil;
  }
  AnyPromise *promise = [self.delegate paginate:parameters];
  if (promise) {
    @weakify(self);
    return promise.then(^(OVCResponse *response) {
      NSArray *result = response.result;
      @strongify(self);
      self.hasDataLoaded = result && result.count >= 0;
      if (self.hasDataLoaded) {
        if (isRefresh) {
          self.nextPage = self.firstPage + 1;
        } else {
          self.nextPage += 1;
        }
        self.hasMorePages = result && result.count == self.pageSize;
      } else {
        self.hasMorePages = NO;
      }
      return result;
    }).ensure(^{
      self.refresh = NO;
      self.loading = NO;
    });
  }
  return nil;
}

#pragma mark - Setter

- (void)setCustomPageName:(NSString *)customPageName {
  _customPageName = customPageName;
  if (customPageName.length) {
    self.paramPage = customPageName;
  }
}

- (void)setCustomPageSize:(NSString *)customPageSize {
  _customPageSize = customPageSize;
  if (customPageSize.length) {
    self.paramPageSize = customPageSize;
  }
}

@end
/////////////////////////////
/////////////////////////////
