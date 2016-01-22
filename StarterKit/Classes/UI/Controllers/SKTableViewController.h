//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <TGRDataSource/TGRFetchedResultsTableViewController.h>
#import "SKPaginator.h"
#import "SKManagedHTTPSessionManager.h"

@class SKTableViewControllerBuilder;

typedef void (^SKTableViewControllerBuilderBlock)(SKTableViewControllerBuilder *builder);

@interface SKTableViewController : TGRFetchedResultsTableViewController <SKPaginatorDelegate>

@property(nonatomic, strong, readonly) SKManagedHTTPSessionManager *httpSessionManager;

- (void)setupTableView;

- (void)showShimmerHUD;
- (void)hideShimmerHUD;

- (void)refreshData;
- (void)loadMoreData;

+ (id)createWithBuilder:(SKTableViewControllerBuilderBlock )block;
- (id)initWithBuilder:(SKTableViewControllerBuilder *)builder;

@end