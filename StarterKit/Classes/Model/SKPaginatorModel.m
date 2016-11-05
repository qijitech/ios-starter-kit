//
// Created by 杨玉刚 on 11/5/16.
//

#import "SKPaginatorModel.h"


@implementation SKPaginatorModel

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

//+ (NSValueTransformer *)dataJSONTransformer {
//  return [MTLJSONAdapter arrayTransformerWithModelClass:[QJImage class]];
//}

@end