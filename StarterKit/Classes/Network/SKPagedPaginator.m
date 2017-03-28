//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKPagedPaginator.h"
#import "SKPaginatorModel.h"
#import <Overcoat/OVCResponse.h>
#import <libextobjc/EXTScope.h>

/////////////////////////////
/////////////////////////////
@interface SKPagedPaginator ()
@property(nonatomic, assign) NSUInteger firstPage;
@property(nonatomic, assign) NSUInteger nextPage;
@end

@implementation SKPagedPaginator

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
      @strongify(self);
      [OVCResponse class];
      SKPaginatorModel *result = response.result;

      id data = response.rawResult[@"data"];
      NSError *error = nil;
      result.mData = [self transformedResult:data error:&error];

      self.hasDataLoaded = result && result.size >= 0;
      if (self.hasDataLoaded) {
        if (isRefresh) {
          self.nextPage = self.firstPage + 1;
        } else {
          self.nextPage += 1;
        }
        self.hasMorePages = result.hasMorePages;
      } else {
        self.hasMorePages = NO;
      }
      return result;
    }).always(^{
      self.refresh = NO;
      self.loading = NO;
    });
  }
  return nil;
}

- (id)transformedResult:(id)JSONObject error:(NSError **)error{
  if (self.resultClass == nil) {
    return JSONObject;
  }

  id result = JSONObject;

  NSValueTransformer *valueTransformer = nil;
  if ([result isKindOfClass:[NSDictionary class]]) {
    valueTransformer = [MTLJSONAdapter dictionaryTransformerWithModelClass:self.resultClass];
  } else if ([result isKindOfClass:[NSArray class]]) {
    valueTransformer = [MTLJSONAdapter arrayTransformerWithModelClass:self.resultClass];
  }

  if ([valueTransformer conformsToProtocol:@protocol(MTLTransformerErrorHandling)]) {
    BOOL success = NO;
    result = [(NSValueTransformer<MTLTransformerErrorHandling> *)valueTransformer transformedValue:result
                                                                                           success:&success
                                                                                             error:error];
    if (!success) {
      result = nil;
    }
  } else {
    result = [valueTransformer transformedValue:result];
  }

  return result;
}

@end
/////////////////////////////
/////////////////////////////
