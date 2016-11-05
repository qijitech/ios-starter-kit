//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKPaginator.h"

@class SKTableViewControllerBuilder;
@class SKTableViewCell;
@class SKPaginatorModel;

typedef void (^SKTableViewControllerBuilderBlock)(SKTableViewControllerBuilder *builder);

@interface SKAbstractTableViewController : UITableViewController <SKPaginatorDelegate>

@property(nonatomic, strong, readonly) SKPaginatorModel *paginatorModel;

@property(nonatomic, strong, readonly) SKPaginator *paginator;

@property(nonatomic, strong, readonly) NSMutableArray *cellMetadata;
@property(nonatomic, strong, readonly) AnyPromise *(^paginateBlock)(NSDictionary *parameters);

// empty properties
@property(nonatomic, strong, readonly) UIColor *titleColor;
@property(nonatomic, strong, readonly) UIFont *titleFont;
@property(nonatomic, strong, readonly) UIColor *subtitleColor;
@property(nonatomic, strong, readonly) UIFont *subtitleFont;

// load properties
@property(nonatomic, assign, readonly) BOOL canRefresh;
@property(nonatomic, assign, readonly) BOOL canLoadMore;

// for internal
- (void)cancelAllRequests;
- (void)onDataLoaded:(NSArray *)data isRefresh:(BOOL)isRefresh;
- (void)setupTableView;

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

- (BOOL)isLoadMoreOrEmptyCell:(NSIndexPath *)indexPath;
- (BOOL)configureCell:(SKTableViewCell *) cell withItem:(id)item;
- (NSString *)cellReuseIdentifier:(id)item indexPath:(NSIndexPath *)indexPath;

/**
 Returns a data source item in a particular location.
 */
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
/**
 Returns the location for the specified data source item.
 */
- (NSIndexPath *)indexPathForItem:(id)item;

@end