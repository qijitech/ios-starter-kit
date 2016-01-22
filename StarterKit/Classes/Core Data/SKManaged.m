//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKManaged.h"
#import "SKNetworkConfig.h"


static NSString *const kIdentifierKey = @"identifier";

@interface SKManaged ()
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) OVCManagedStore *store;
@end

@implementation SKManaged

+ (SKManaged *)sharedInstance {
  static id sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

+ (NSFetchRequest *)fetchRequestEntityName:(NSString *)entityName {
  return [[self class] fetchRequestWithPredicate:nil
                                      entityName:entityName
                                  fetchBatchSize:[SKNetworkConfig sharedInstance].perPage];
}

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate
                                   entityName:(NSString *)entityName
                               fetchBatchSize:(NSUInteger)fetchBatchSize {
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
  [fetchRequest setFetchBatchSize:fetchBatchSize];

  if (predicate) {
    [fetchRequest setPredicate:predicate];
  }

  NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kIdentifierKey
                                                               ascending:NO];
  [fetchRequest setSortDescriptors:@[descriptor]];

  return fetchRequest;
}

- (NSNumber *)firstModelIdentifier:(NSString *)entityName {
  NSFetchRequest *fetchRequest = [[self class] fetchRequestEntityName:entityName];

  NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kIdentifierKey
                                                               ascending:YES];
  [fetchRequest setSortDescriptors:@[descriptor]];

  [fetchRequest setResultType:NSDictionaryResultType];
  [fetchRequest setPropertiesToFetch:@[kIdentifierKey]];
  [fetchRequest setFetchLimit:1];

  NSDictionary *result = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                                   error:NULL] firstObject];
  return result[kIdentifierKey];
}

- (NSNumber *)lastModelIdentifier:(NSString *)entityName {
  NSFetchRequest *fetchRequest = [[self class] fetchRequestEntityName:entityName];

  [fetchRequest setResultType:NSDictionaryResultType];
  [fetchRequest setPropertiesToFetch:@[kIdentifierKey]];
  [fetchRequest setFetchLimit:1];

  NSDictionary *result = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                                   error:NULL] firstObject];
  return result[kIdentifierKey];
}

#pragma mark - Private properties

- (NSManagedObjectContext *)managedObjectContext {
  if (!_managedObjectContext) {
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = self.store.persistentStoreCoordinator;
  }

  return _managedObjectContext;
}

- (OVCManagedStore *)store {
  if (!_store) {
    // 这里看怎么设置比较好，暂时以当前类名来设置
    _store = [OVCManagedStore managedStoreWithCacheName:NSStringFromClass([self class])];
  }
  return _store;
}

@end
