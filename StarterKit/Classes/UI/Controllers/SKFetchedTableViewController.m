//
// Created by Hammer on 3/24/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKFetchedTableViewController.h"
#import <libextobjc/EXTScope.h>
#import "SKTableViewCell.h"
#import "SKFetchedResultsDataSource.h"
#import "SKFetchedResultsDataSourceBuilder.h"
#import "SKLoadMoreTableViewCell.h"
#import "SKManaged.h"
#import "SKManagedHTTPSessionManager.h"
#import "SKTableViewControllerBuilder.h"

@interface SKFetchedTableViewController ()
@property(nonatomic, strong) SKManagedHTTPSessionManager *httpSessionManager;

@property(nonatomic, copy) NSString *entityName;
@property(nonatomic, copy) NSPredicate *predicate;
@property(nonatomic, copy) NSArray<NSSortDescriptor *> *sortDescriptors;

@property(strong, nonatomic) NSMutableIndexSet *insertedSections;
@property(strong, nonatomic) NSMutableIndexSet *deletedSections;
@property(strong, nonatomic) NSMutableArray *insertedRows;
@property(strong, nonatomic) NSMutableArray *deletedRows;
@property(strong, nonatomic) NSMutableArray *updatedRows;
@end

@implementation SKFetchedTableViewController

- (void)initWithBuilder:(SKTableViewControllerBuilder *)builder {
  NSParameterAssert(builder);
  _predicate = builder.predicate;
  _entityName = builder.entityName;
  _sortDescriptors = builder.sortDescriptors;
  [super initWithBuilder:builder];
}

- (SKManagedHTTPSessionManager *)httpSessionManager {
  if (!_httpSessionManager) {
    _httpSessionManager = [[SKManagedHTTPSessionManager alloc]
        initWithManagedObjectContext:[SKManaged sharedInstance].managedObjectContext];
  }
  return _httpSessionManager;
}

- (void)cancelAllRequests {
  [self.httpSessionManager invalidateSessionCancelingTasks:YES];
  _httpSessionManager = nil;
}

- (void)setupDataSource {
  @weakify(self);
  self.dataSource = [SKFetchedResultsDataSource createWithBuilder:^(SKFetchedResultsDataSourceBuilder *builder) {
    @strongify(self);
    builder.modelOfClass = [self modelOfClass];
    builder.entityName = [self entityName];
    builder.predicate = [self predicate];
    builder.dequeueReusableCellBlock = ^NSString *(id item, NSIndexPath *indexPath) {
      NSUInteger numbers = [self numberOfObjectsWithSection:indexPath.section];
      if (self.canLoadMore && self.paginator.hasMorePages && indexPath.item == numbers - 1) {
        return [SKLoadMoreTableViewCell cellIdentifier];
      }
      if (self.cellReuseIdentifier) {
        return self.cellReuseIdentifier;
      }
      return self.dequeueReusableCellBlock(item, indexPath);
    };
    builder.configureCellBlock = self.configureCellBlock;
  }];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
  return [self.dataSource itemAtIndexPath:indexPath];
}

- (NSUInteger)numberOfObjectsWithSection:(NSUInteger)section {
  id <NSFetchedResultsSectionInfo> sectionInfo = self.dataSource.fetchedResultsController.sections[section];
  return [sectionInfo numberOfObjects];
}

- (NSUInteger)numberOfObjects {
  return [self.dataSource.fetchedResultsController.fetchedObjects count];
}

- (NSNumber *)lastModelIdentifier:(NSString *)entityName
                  sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors {
  return [[SKManaged sharedInstance] lastModelIdentifier:entityName sortDescriptors:sortDescriptors];
}
- (NSNumber *)firstModelIdentifier:(NSString *)entityName
                   sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors {
  return [[SKManaged sharedInstance] firstModelIdentifier:entityName sortDescriptors:sortDescriptors];
}

#pragma mark - Properties

- (void)setDataSource:(TGRFetchedResultsDataSource *)dataSource {
  if (_dataSource != dataSource) {
    _dataSource.fetchedResultsController.delegate = nil;
    _dataSource = dataSource;
    _dataSource.fetchedResultsController.delegate = self;
    self.tableView.dataSource = dataSource;
    [self performFetch];
  }
}

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

  if (self) {
    _contentAnimationMaximumChangeCount = 100;
  }

  return self;
}

- (void)performFetch {
  if (self.dataSource) {
    NSError *error = nil;
    [self.dataSource.fetchedResultsController performFetch:&error];
    NSAssert(error == nil, @"%@ performFetch: %@", self, error);
  }
  [self.tableView reloadData];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
  switch (type) {
    case NSFetchedResultsChangeInsert:
      [self.insertedSections addIndex:sectionIndex];
      break;
    case NSFetchedResultsChangeDelete:
      [self.deletedSections addIndex:sectionIndex];
      break;
    default:
      break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
  switch (type) {
    case NSFetchedResultsChangeInsert:
      if (![self.insertedSections containsIndex:(NSUInteger) newIndexPath.section]) {
        [self.insertedRows addObject:newIndexPath];
      }
      break;
    case NSFetchedResultsChangeDelete:
      if (![self.deletedSections containsIndex:(NSUInteger) indexPath.section]) {
        [self.deletedRows addObject:indexPath];
      }
      break;
    case NSFetchedResultsChangeUpdate:
      [self.updatedRows addObject:indexPath];
      break;
    case NSFetchedResultsChangeMove:
      if (![self.insertedSections containsIndex:(NSUInteger) newIndexPath.section]) {
        [self.insertedRows addObject:newIndexPath];
      }
      if (![self.deletedSections containsIndex:(NSUInteger) indexPath.section]) {
        [self.deletedRows addObject:indexPath];
      }
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  NSUInteger changeCount = self.insertedSections.count +
      self.deletedSections.count +
      self.insertedRows.count +
      self.deletedRows.count +
      self.updatedRows.count;

  if (changeCount <= self.contentAnimationMaximumChangeCount) {
    [self.tableView beginUpdates];
    [self.tableView deleteSections:self.deletedSections withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView insertSections:self.insertedSections withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView deleteRowsAtIndexPaths:self.deletedRows withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView insertRowsAtIndexPaths:self.insertedRows withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadRowsAtIndexPaths:self.updatedRows withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
  }
  else {
    [self.tableView reloadData];
  }
  self.insertedSections = nil;
  self.deletedSections = nil;
  self.insertedRows = nil;
  self.deletedRows = nil;
  self.updatedRows = nil;
}

#pragma mark - Private

- (NSMutableIndexSet *)insertedSections {
  if (!_insertedSections) {
    _insertedSections = [[NSMutableIndexSet alloc] init];
  }
  return _insertedSections;
}

- (NSMutableIndexSet *)deletedSections {
  if (!_deletedSections) {
    _deletedSections = [[NSMutableIndexSet alloc] init];
  }
  return _deletedSections;
}

- (NSMutableArray *)insertedRows {
  if (!_insertedRows) {
    _insertedRows = [[NSMutableArray alloc] init];
  }
  return _insertedRows;
}

- (NSMutableArray *)deletedRows {
  if (!_deletedRows) {
    _deletedRows = [[NSMutableArray alloc] init];
  }
  return _deletedRows;
}

- (NSMutableArray *)updatedRows {
  if (!_updatedRows) {
    _updatedRows = [[NSMutableArray alloc] init];
  }
  return _updatedRows;
}

@end