//
// Created by Hammer on 3/24/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKTableViewController.h"
#import "SKHTTPSessionManager.h"
#import "SKModel.h"

@interface SKTableViewController()
@property (copy, nonatomic) NSMutableArray *items;
@property(nonatomic, strong) SKHTTPSessionManager *httpSessionManager;
@end

@implementation SKTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _items = [NSMutableArray new];
}

- (SKHTTPSessionManager *)httpSessionManager {
  if (!_httpSessionManager) {
    _httpSessionManager = [SKHTTPSessionManager new];
  }
  return _httpSessionManager;
}

- (void)cancelAllRequests {
  [self.httpSessionManager invalidateSessionCancelingTasks:YES];
  _httpSessionManager = nil;
}

- (NSNumber *)lastModelIdentifier:(NSString *)entityName
                        predicate:(NSPredicate *)predicate
                  sortDescriptors:(NSArray<NSDictionary *> *)sortDescriptors {
  NSUInteger count = self.items.count;
  if (count <= 0) {
    return nil;
  }
  id item = self.items[(count - 1)];
  if ([item isKindOfClass:[SKModel class]]) {
    SKModel *model = (SKModel *) item;
    return model.identifier;
  }
  return nil;
}

- (NSNumber *)firstModelIdentifier:(NSString *)entityName
                         predicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray<NSDictionary *> *)sortDescriptors {
  return nil;
}

- (void)onDataLoaded:(NSArray *)data isRefresh:(BOOL)isRefresh {
  if (isRefresh && data && data.count > 0) {
    [self.items removeAllObjects];
  }
  [self.items addObjectsFromArray:data];
  [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger numberOfObjects = self.items.count;
  if (self.canLoadMore && numberOfObjects >= self.paginator.pageSize) {
    return numberOfObjects + 1;
  }
  return numberOfObjects;
}

#pragma mark - SKAbstractTableViewController

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
  return self.items[(NSUInteger)indexPath.row];
}

- (NSIndexPath *)indexPathForItem:(id)item {
  NSIndexPath *indexPath = nil;
  NSUInteger index = [self.items indexOfObject:item];

  if (index != NSNotFound) {
    indexPath = [NSIndexPath indexPathForRow:(NSInteger)index inSection:0];
  }
  return indexPath;
}

@end