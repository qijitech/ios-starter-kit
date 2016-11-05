//
// Created by 杨玉刚 on 11/5/16.
//

#import <Mantle/Mantle.h>

@interface SKPaginatorModel : MTLModel <MTLJSONSerializing>

@property(nonatomic, strong) NSNumber *total;
@property(nonatomic, strong) NSNumber *perPage;
@property(nonatomic, strong) NSNumber *currentPage;
@property(nonatomic, strong) NSNumber *lastPage;

@property(nonatomic, strong) NSArray *mData;

- (bool)hasMorePages;

- (NSArray *)data;

- (NSUInteger)size;

@end