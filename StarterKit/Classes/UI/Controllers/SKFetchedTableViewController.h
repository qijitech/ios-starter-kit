//
// Created by Hammer on 3/24/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//


#import <CoreData/CoreData.h>
#import "SKAbstractTableViewController.h"

@class SKManagedHTTPSessionManager;

@interface SKFetchedTableViewController : SKAbstractTableViewController <NSFetchedResultsControllerDelegate>

@property(nonatomic, strong, readonly) SKManagedHTTPSessionManager *httpSessionManager;

/**
 The data source used by this view controller.
 */
@property(strong, nonatomic) TGRFetchedResultsDataSource *dataSource;

/**
 Maximum number of changes in the fetched results controller that will be animated. Default is 100.
 */
@property(nonatomic) NSUInteger contentAnimationMaximumChangeCount;

/**
 Performs the fetch and reloads the table view.
 This method is called everytime the `dataSource` property changes.
 */
- (void)performFetch;

@end