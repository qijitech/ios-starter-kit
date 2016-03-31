//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TGRDataSource_qijitech/TGRFetchedResultsDataSource.h>
#import "SKPaginator.h"

@class SKTableViewControllerBuilder;
@class SKTableViewCell;

typedef void (^SKTableViewControllerBuilderBlock)(SKTableViewControllerBuilder *builder);

@interface SKAbstractTableViewController : UITableViewController <SKPaginatorDelegate>

@property(nonatomic, strong, readonly) SKPaginator *paginator;

@property(nonatomic, strong, readonly) Class modelOfClass;
@property(nonatomic, strong, readonly) NSMutableArray *cellMetadata;
@property(nonatomic, strong, readonly) AnyPromise *(^paginateBlock)(NSDictionary *parameters);

// optional
@property(nonatomic, copy, readonly) NSString *cellReuseIdentifier;
@property(nonatomic, copy, readonly) TGRDataSourceDequeueReusableCellBlock dequeueReusableCellBlock;
@property(nonatomic, copy, readonly) TGRDataSourceCellBlock configureCellBlock;

@property(nonatomic, strong, readonly) UIColor *titleColor;
@property(nonatomic, strong, readonly) UIFont *titleFont;
@property(nonatomic, strong, readonly) UIColor *subtitleColor;
@property(nonatomic, strong, readonly) UIFont *subtitleFont;

@property(nonatomic, assign, readonly) BOOL canRefresh;
@property(nonatomic, assign, readonly) BOOL canLoadMore;

// for internal
- (NSUInteger)numberOfObjectsWithSection:(NSInteger )section;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
- (NSUInteger)numberOfObjects;
- (void)cancelAllRequests;
- (void)onDataLoaded:(NSArray *)data isRefresh:(BOOL)isRefresh;
- (void)setupTableView;
- (void)setupDataSource;
- (NSString *)buildReusableCellBlock:(NSIndexPath *)indexPath item:(id)item;
- (void)buildConfigureCellBlock:(SKTableViewCell *)cell item:(id)item;

- (void)showIndicatorView;
- (void)hideIndicatorView;

- (void)refreshData;
- (void)loadMoreData;

- (void)createWithBuilder:(SKTableViewControllerBuilderBlock )block;
- (void)initWithBuilder:(SKTableViewControllerBuilder *)builder;

// for empty 可继承实现
- (NSString *)emptyTitle;
- (NSString *)emptySubtitle;
- (NSString *)emptyImage;

@end