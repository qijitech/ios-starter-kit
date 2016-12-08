//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <PromiseKit/PromiseKit.h>

@protocol SKPaginatorDelegate <NSObject>
@required
- (void)networkOnStart:(BOOL)isRefresh;
- (AnyPromise *)paginate:(NSDictionary *)parameters;

- (NSString *)lastModelIdentifier:(NSString *)entityName
                        predicate:(NSPredicate *)predicate
                  sortDescriptors:(NSArray<NSDictionary *> *)sortDescriptors;
- (NSString *)firstModelIdentifier:(NSString *)entityName
                         predicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray<NSDictionary *> *)sortDescriptors;
@end

@interface SKPaginator : NSObject
@property (nonatomic, copy, readonly) NSString *paramPageSize;
@property (nonatomic, copy, readonly) NSString *paramMaxId;
@property (nonatomic, copy, readonly) NSString *paramSinceId;
@property (nonatomic, copy, readonly) NSString *paramPage;

@property(nonatomic, assign) BOOL hasDataLoaded;
@property(nonatomic, assign, getter=isRefresh) BOOL refresh;
@property(nonatomic, assign, getter=isLoading) BOOL loading;
@property(nonatomic, assign) BOOL hasMorePages;
@property(nonatomic, assign) BOOL hasError;
@property(nonatomic, strong) NSError *error;

@property(nonatomic, assign, readonly) NSUInteger pageSize;

@property(nonatomic, weak) id <SKPaginatorDelegate> delegate;
- (AnyPromise *)refresh;
- (AnyPromise *)loadMore;
@end