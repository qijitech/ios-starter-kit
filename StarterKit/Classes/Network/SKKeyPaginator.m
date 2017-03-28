//
// Created by 杨玉刚 on 11/5/16.
//

#import "SKKeyPaginator.h"

#import <Overcoat/OVCResponse.h>
#import <libextobjc/EXTScope.h>

/////////////////////////////
/////////////////////////////
@interface SKKeyPaginator ()
@end

@implementation SKKeyPaginator

- (AnyPromise *)refresh {
  if (self.refresh || self.loading) {
    return nil;
  }
  if (self.delegate && [self.delegate respondsToSelector:@selector(networkOnStart:)]) {
    self.hasMorePages = YES;
    self.error = nil;
    self.hasError = NO;
    self.refresh = YES;
    self.loading = YES;
    [self.delegate networkOnStart:YES];
  }

  if (self.delegate && [self.delegate respondsToSelector:@selector(paginate:)]) {
    NSDictionary *parameters = @{};
    if ([self.delegate respondsToSelector:@selector(firstModelIdentifier:predicate:sortDescriptors:)]) {
      NSString *identifier = [self.delegate firstModelIdentifier:self.entityName predicate:self.predicate sortDescriptors:self.sortDescriptors];
      if (identifier) {
        parameters = [parameters mtl_dictionaryByAddingEntriesFromDictionary:@{self.paramSinceId : identifier}];
      }
    }
    return [self paginate:parameters isRefresh:YES];
  }

  return nil;
}

- (AnyPromise *)loadMore {
  if (self.refresh || self.loading) {
    return nil;
  }
  if (self.delegate && [self.delegate respondsToSelector:@selector(networkOnStart:)]) {
    self.hasMorePages = YES;
    self.error = nil;
    self.hasError = NO;
    self.refresh = NO;
    self.loading = YES;
    [self.delegate networkOnStart:NO];
  }

  if (self.delegate && [self.delegate respondsToSelector:@selector(paginate:)]) {
    NSString *identifier;
    if ([self.delegate respondsToSelector:@selector(lastModelIdentifier:predicate:sortDescriptors:)]) {
      identifier = [self.delegate lastModelIdentifier:self.entityName predicate:self.predicate sortDescriptors:self.sortDescriptors];
    }

    NSAssert(identifier, @"loadMore should not be called when the cache is empty");
    NSDictionary *parameters = @{self.paramMaxId : identifier, self.paramPageSize : @(self.pageSize)};
    return [self paginate:parameters isRefresh:false];
  }

  return nil;
}

- (AnyPromise *)paginate:(NSDictionary *)parameters isRefresh:(BOOL)isRefresh {
  if (!self.delegate || ![self.delegate respondsToSelector:@selector(paginate:)]) {
    return nil;
  }
  AnyPromise *promise = [self.delegate paginate:[parameters mutableCopy]];
  if (promise) {
    @weakify(self);
    return promise.then(^(OVCResponse *response) {
      NSArray *result = response.result;
      @strongify(self);
      self.hasDataLoaded = result && result.count >= 0;
      if (self.hasDataLoaded) {
        self.hasMorePages = result.count >= self.pageSize;
      } else {
        self.hasMorePages = NO;
      }
      self.hasError = NO;
      self.error = nil;
      return result;
    }).catch(^(NSError *error) {
      self.hasError = YES;
      self.error = error;
    }).always(^{
      self.refresh = NO;
      self.loading = NO;
    });
  }
  return nil;
}
@end
/////////////////////////////
