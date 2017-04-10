//
//  SKPagedListPaginator.h
//  Pods
//
//  Created by shuu on 2017/4/10.
//
//

#import "SKPaginator.h"

@interface SKPagedListPaginator : SKPaginator
@property(nonatomic, assign, readonly) NSUInteger firstPage;
@property(nonatomic, assign, readonly) NSUInteger nextPage;

@property(nonatomic, strong) Class resultClass;

@property (nonatomic, copy) NSString *customPageSize;
@property (nonatomic, copy) NSString *customPageName;

@end
