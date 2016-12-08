//
// Created by Hammer on 3/24/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKFetchedTableViewController.h"
#import "SKManaged.h"
#import "SKManagedHTTPSessionManager.h"
#import "SKTableViewControllerBuilder.h"

@interface SKFetchedTableViewController ()
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property(nonatomic, strong) SKManagedHTTPSessionManager *httpSessionManager;

@property(nonatomic, strong) Class modelOfClass;
@property(nonatomic, copy) NSString *entityName;
@property(nonatomic, strong) NSPredicate *predicate;
@property(nonatomic, strong) NSArray<NSDictionary *> *sortDescriptors;

@property(strong, nonatomic) NSMutableIndexSet *insertedSections;
@property(strong, nonatomic) NSMutableIndexSet *deletedSections;
@property(strong, nonatomic) NSMutableArray *insertedRows;
@property(strong, nonatomic) NSMutableArray *deletedRows;
@property(strong, nonatomic) NSMutableArray *updatedRows;
@end

@implementation SKFetchedTableViewController

- (void)initWithBuilder:(SKTableViewControllerBuilder *)builder {
  NSParameterAssert(builder);
  NSParameterAssert(builder.entityName);
  NSParameterAssert(builder.modelOfClass);

  _modelOfClass = builder.modelOfClass;
  _predicate = builder.predicate;
  _entityName = builder.entityName;
  _sortDescriptors = builder.sortDescriptors;
  [super initWithBuilder:builder];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  SKManaged *managed = [SKManaged sharedInstance];

  NSFetchRequest *fetchRequest = [SKManaged fetchRequestWithPredicate:self.predicate
                                                           entityName:self.entityName
                                                      sortDescriptors:self.sortDescriptors
                                                       fetchBatchSize:nil];
  self.fetchedResultsController = [[NSFetchedResultsController alloc]
      initWithFetchRequest:fetchRequest
      managedObjectContext:managed.managedObjectContext
        sectionNameKeyPath:nil
                 cacheName:nil];
  self.fetchedResultsController.delegate = self;
  [self performFetch];
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

- (NSString *)lastModelIdentifier:(NSString *)entityName
                        predicate:(NSPredicate *)predicate
                  sortDescriptors:(NSArray<NSDictionary *> *)sortDescriptors {
  return [[SKManaged sharedInstance] lastModelIdentifier:entityName
                                               predicate:predicate sortDescriptors:sortDescriptors];
}

- (NSString *)firstModelIdentifier:(NSString *)entityName
                         predicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray<NSDictionary *> *)sortDescriptors {
  return [[SKManaged sharedInstance] firstModelIdentifier:entityName
                                                predicate:predicate sortDescriptors:sortDescriptors];
}

#pragma mark - Properties

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

  if (self) {
    _contentAnimationMaximumChangeCount = 100;
  }

  return self;
}

- (void)performFetch {
  NSError *error = nil;
  [self.fetchedResultsController performFetch:&error];
  NSAssert(error == nil, @"%@ performFetch: %@", self, error);
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



- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
  return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForItem:(id)item {
  return [self.fetchedResultsController indexPathForObject:item];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
  NSUInteger numberOfObjects = [sectionInfo numberOfObjects];
  if (self.canLoadMore && numberOfObjects >= self.paginator.pageSize) {
    return numberOfObjects + 1;
  }
  return numberOfObjects;
}

@end