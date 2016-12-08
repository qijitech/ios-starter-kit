//
//  SKPaginatorContractModel.h
//
//  Created by shuu on 2016/12/6.
//

#import <Mantle/Mantle.h>

@interface SKPaginatorContractModel : MTLModel <MTLJSONSerializing>

@property(nonatomic, strong) NSNumber *total;
@property(nonatomic, strong) NSNumber *perPage;
@property(nonatomic, strong) NSNumber *currentPage;
@property(nonatomic, strong) NSNumber *lastPage;

@property(nonatomic, strong) NSArray *mData;

- (bool)hasMorePages;

- (NSArray *)data;

- (NSUInteger)size;

@end
