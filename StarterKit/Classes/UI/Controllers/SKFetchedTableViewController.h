//
// Created by Hammer on 3/24/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//


#import <CoreData/CoreData.h>
#import "SKAbstractTableViewController.h"

@class SKManagedHTTPSessionManager;

@interface SKFetchedTableViewController : SKAbstractTableViewController <NSFetchedResultsControllerDelegate>

/**
 The `NSFetchedResultsController` object managed by this data source.
 */
@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

@property(nonatomic, strong, readonly) SKManagedHTTPSessionManager *httpSessionManager;

@property(nonatomic, strong, readonly) Class modelOfClass;
@property(nonatomic, copy, readonly) NSString *entityName;
@property(nonatomic, strong, readonly) NSPredicate *predicate;
@property(nonatomic, strong, readonly) NSArray<NSDictionary *> *sortDescriptors;

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