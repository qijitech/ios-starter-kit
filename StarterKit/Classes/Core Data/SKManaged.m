//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKManaged.h"


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

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate
                                   entityName:(NSString *)entityName {
  return [[self class] fetchRequestWithPredicate:predicate entityName:entityName sortDescriptors:nil];
}

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate
                                   entityName:(NSString *)entityName
                              sortDescriptors:(NSArray<NSDictionary *> *)sortDescriptors {
  return [[self class] fetchRequestWithPredicate:predicate
                                      entityName:entityName
                                 sortDescriptors:sortDescriptors fetchBatchSize:nil];
}

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate
                                   entityName:(NSString *)entityName
                              sortDescriptors:(NSArray<NSDictionary *> *)sortDescriptors
                               fetchBatchSize:(NSUInteger)fetchBatchSize {
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
  [fetchRequest setFetchBatchSize:fetchBatchSize];

  if (predicate) {
    [fetchRequest setPredicate:predicate];
  }

  if (sortDescriptors) {
    NSMutableArray<NSSortDescriptor *> *descriptors = [NSMutableArray new];
    for (NSDictionary *sortDescriptor in sortDescriptors) {
      NSString *key = sortDescriptor[@"key"];
      BOOL ascending = [sortDescriptor[@"ascending"] boolValue];
      NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
      [descriptors addObject:descriptor];
    }
    [fetchRequest setSortDescriptors:descriptors];
  } else {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kIdentifierKey
                                                                 ascending:NO];
    [fetchRequest setSortDescriptors:@[descriptor]];
  }
  return fetchRequest;
}

- (NSString *)firstModelIdentifier:(NSString *)entityName
                         predicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray<NSDictionary *> *)sortDescriptors {
  NSFetchRequest *fetchRequest = [[self class] fetchRequestWithPredicate:predicate
                                                              entityName:entityName
                                                         sortDescriptors:sortDescriptors];
  [fetchRequest setResultType:NSDictionaryResultType];
  [fetchRequest setPropertiesToFetch:@[kIdentifierKey]];
  [fetchRequest setFetchLimit:1];
  NSDictionary *result = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                                   error:NULL] firstObject];
  return result[kIdentifierKey];
}

- (NSString *)lastModelIdentifier:(NSString *)entityName
                        predicate:(NSPredicate *)predicate
                  sortDescriptors:(NSArray<NSDictionary *> *)sortDescriptors {
  NSFetchRequest *fetchRequest = [[self class] fetchRequestWithPredicate:predicate entityName:entityName];

  if (sortDescriptors) {
    NSMutableArray<NSSortDescriptor *> *descriptors = [NSMutableArray new];
    for (NSDictionary *sortDescriptor in sortDescriptors) {
      NSString *key = sortDescriptor[@"key"];
      BOOL ascending = [sortDescriptor[@"ascending"] boolValue];
      NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:!ascending];
      [descriptors addObject:descriptor];
    }
    [fetchRequest setSortDescriptors:descriptors];
  } else {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kIdentifierKey
                                                                 ascending:YES];
    [fetchRequest setSortDescriptors:@[descriptor]];
  }

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
    NSString *cacheName = [[NSBundle mainBundle] infoDictionary][(__bridge NSString *) kCFBundleExecutableKey]
        ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *) kCFBundleIdentifierKey];
    _store = [OVCManagedStore managedStoreWithCacheName:cacheName];
  }
  return _store;
}

@end
