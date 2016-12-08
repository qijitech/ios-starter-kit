//
//  SKPagedCustomPaginator.h
//
//  Created by shuu on 2016/12/5.
//

#import "SKPaginator.h"

@protocol SKPagedContractPaginatorDelegate <NSObject>
@required

@property(nonatomic, copy) NSString *resultKeyValue;

@optional
@property(nonatomic, strong) Class paginatorModelOfClass;
@property(nonatomic, copy) NSString *subResultKeyValue;

@end

@interface SKPagedContractPaginator : SKPaginator <SKPagedContractPaginatorDelegate>
@property(nonatomic, assign, readonly) NSUInteger firstPage;
@property(nonatomic, assign, readonly) NSUInteger nextPage;
@property(nonatomic, strong, readonly) SKPagedContractPaginator *contractData;

@property(nonatomic, strong) Class resultClass;

@end
