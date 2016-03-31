//
// Created by Hammer on 3/24/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKTableViewController.h"
#import "SKHTTPSessionManager.h"
#import <libextobjc/EXTScope.h>
#import "SKTableViewCell.h"
#import "SKLoadMoreTableViewCell.h"
#import "SKLoadMoreEmptyTableViewCell.h"
#import "SKArrayDataSourceBuilder.h"
#import "SKModel.h"

@interface SKTableViewController()

@property(nonatomic, strong) SKHTTPSessionManager *httpSessionManager;
@end

@implementation SKTableViewController

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

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
  return [self.dataSource itemAtIndexPath:indexPath];
}

- (NSUInteger)numberOfObjectsWithSection:(NSInteger)section {
  return self.dataSource.items.count;
}

- (NSUInteger)numberOfObjects {
  return self.dataSource.items.count;
}

- (NSNumber *)lastModelIdentifier:(NSString *)entityName
                        predicate:(NSPredicate *)predicate
                  sortDescriptors:(NSArray<NSDictionary *> *)sortDescriptors {
  NSArray *items = self.dataSource.items;
  NSUInteger count = items.count;
  if (count <= 0) {
    return nil;
  }
  id item = items[(count - 1)];
  if ([item isKindOfClass:[SKModel class]]) {
    SKModel *model = (SKModel *) item;
    return model.identifier;
  }
  return nil;
}

- (NSNumber *)firstModelIdentifier:(NSString *)entityName
                         predicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray<NSDictionary *> *)sortDescriptors {
//  if (self.dataSource.items.count <= 0) {
//    return nil;
//  }
//  id item = self.dataSource.items[0];
//  if ([item isKindOfClass:[SKModel class]]) {
//    SKModel *model = (SKModel *)item;
//    return model.identifier;
//  }
  return nil;
}

- (void)setupDataSource {
  @weakify(self);
  self.dataSource = [SKArrayDataSource createWithBuilder:^(SKArrayDataSourceBuilder *builder) {
    @strongify(self);
    builder.dequeueReusableCellBlock = ^NSString *(id item, NSIndexPath *indexPath) {
      return [self buildReusableCellBlock:indexPath item:item];
    };
    builder.configureCellBlock = ^(SKTableViewCell *cell, id item) {
      [self buildConfigureCellBlock:cell item:item];
    };
  }];
}

- (void)onDataLoaded:(NSArray *)data isRefresh:(BOOL)isRefresh {
  [self.dataSource addItems:data isRefresh:isRefresh];
  [self.tableView reloadData];
}

- (void)setDataSource:(SKArrayDataSource *)dataSource {
  if (_dataSource != dataSource) {
    _dataSource = dataSource;
    self.tableView.dataSource = dataSource;
    [self.tableView reloadData];
  }
}

@end