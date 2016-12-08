//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <OvercoatCoreData/OVCManagedStore.h>

@interface SKManaged : NSObject

@property(nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong, readonly) OVCManagedStore *store;

+ (SKManaged *)sharedInstance;

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate
                                   entityName:(NSString *)entityName;

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate
                                   entityName:(NSString *)entityName
                              sortDescriptors:(NSArray<NSDictionary *> *)sortDescriptors;

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate
                                   entityName:(NSString *)entityName
                              sortDescriptors:(NSArray<NSDictionary *> *)sortDescriptors
                               fetchBatchSize:(NSUInteger)fetchBatchSize;

- (NSString *)firstModelIdentifier:(NSString *)entityName
                         predicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;

- (NSString *)lastModelIdentifier:(NSString *)entityName
                        predicate:(NSPredicate *)predicate
                  sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;

@end