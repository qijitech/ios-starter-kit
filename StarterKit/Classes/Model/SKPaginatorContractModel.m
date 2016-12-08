//
//  SKPaginatorContractModel.m
//
//  Created by shuu on 2016/12/6.
//

#import "SKPaginatorContractModel.h"

@implementation SKPaginatorContractModel

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"total" : @"total",
             @"perPage" : @"per_page",
             @"currentPage" : @"current_page",
             @"lastPage" : @"last_page",
             };
}

- (bool)hasMorePages {
    return self.currentPage < self.lastPage && self.size >= [self.perPage unsignedIntegerValue];
}

- (NSArray *)data {
    return _mData;
}

- (NSUInteger)size {
    return [self.mData count];
}

@end
