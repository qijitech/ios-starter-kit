//
//  SKPagedCustomPaginator.m
//
//  Created by shuu on 2016/12/5.
//

#import "SKPagedContractPaginator.h"
#import "SKPaginatorContractModel.h"
#import <Overcoat/OVCResponse.h>
#import <libextobjc/EXTScope.h>

@interface SKPagedContractPaginator ()
@property(nonatomic, assign) NSUInteger firstPage;
@property(nonatomic, assign) NSUInteger nextPage;
@property(nonatomic, strong) SKPagedContractPaginator *contractData;

@end

@implementation SKPagedContractPaginator
@synthesize resultKeyValue = _resultKeyValue;
@synthesize subResultKeyValue = _subResultKeyValue;
@synthesize paginatorModelOfClass = _paginatorModelOfClass;

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
            SKPaginatorContractModel *result = response.result;
            id data;
            NSAssert(self.resultKeyValue, @"No resultKeyValue");
            if (!self.subResultKeyValue) {
              data = response.rawResult[self.resultKeyValue];
            } else {
              data = response.rawResult[self.resultKeyValue][self.subResultKeyValue];
            }
            NSError *error = nil;
            result.mData = [self transformedResult:data error:&error];
            if (self.paginatorModelOfClass) {
              NSError *dataError = nil;
              if (!self.contractData || isRefresh) {
                self.contractData = [MTLJSONAdapter modelOfClass:self.paginatorModelOfClass fromJSONDictionary:response.rawResult error:&dataError];
              }
            }
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
