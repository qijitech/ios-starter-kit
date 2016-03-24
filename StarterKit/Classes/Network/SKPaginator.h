//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <PromiseKit/PromiseKit.h>

@protocol SKPaginatorDelegate <NSObject>
@required
- (void)networkOnStart:(BOOL)isRefresh;
- (AnyPromise *)paginate:(NSMutableDictionary *)parameters;

- (NSNumber *)lastModelIdentifier:(NSString *)entityName sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;
- (NSNumber *)firstModelIdentifier:(NSString *)entityName sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;
@end

@interface SKPaginator : NSObject
@property(nonatomic, assign, readonly) BOOL hasDataLoaded;
@property(nonatomic, assign, getter=isRefresh) BOOL refresh;
@property(nonatomic, assign, getter=isLoading) BOOL loading;
@property(nonatomic, assign) BOOL hasMorePages;
@property(nonatomic, assign) BOOL hasError;

@property(nonatomic, assign, readonly) NSUInteger pageSize;

@property(nonatomic, weak) id <SKPaginatorDelegate> delegate;
- (AnyPromise *)refresh;
- (AnyPromise *)loadMore;
@end

@interface SKPagedPaginator : SKPaginator
@property(nonatomic, assign, readonly) NSUInteger firstPage;
@property(nonatomic, assign, readonly) NSUInteger nextPage;
@end

@interface SKKeyPaginator : SKPaginator

@property(nonatomic, assign) NSString *entityName;
@property(nonatomic, copy) NSArray<NSSortDescriptor *> *sortDescriptors;

@end