//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Mantle/MTLModel.h>
#import <MTLManagedObjectAdapter/MTLManagedObjectAdapter.h>
#import "SKFetchedResultsDataSource.h"
#import "SKFetchedResultsDataSourceBuilder.h"
#import "SKManaged.h"

static NSString * const kIdentifierKey = @"identifier";

@interface SKFetchedResultsDataSource ()

@property (strong, nonatomic, readonly) Class modelOfClass;

@end

@implementation SKFetchedResultsDataSource

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
  NSManagedObject *item = [super itemAtIndexPath:indexPath];
  return [MTLManagedObjectAdapter modelOfClass:self.modelOfClass fromManagedObject:item error:NULL];
}

+ (instancetype)createWithBuilder:(SKFetchedResultsDataSourceBuilderBlock)block {
  NSParameterAssert(block);
  SKFetchedResultsDataSourceBuilder *builder = [[SKFetchedResultsDataSourceBuilder alloc] init];
  block(builder);
  return [builder build];
}

- (instancetype)initWithBuilder:(SKFetchedResultsDataSourceBuilder *)builder {
  NSParameterAssert(builder);
  NSParameterAssert(builder.entityName);
  NSParameterAssert(builder.dequeueReusableCellBlock);
  NSParameterAssert(builder.configureCellBlock);

  SKManaged *managed = [SKManaged sharedInstance];
  NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
      initWithFetchRequest:[[SKManaged class] fetchRequestEntityName:builder.entityName]
      managedObjectContext:managed.managedObjectContext
        sectionNameKeyPath:nil
                 cacheName:nil];

  if (self = [super initWithFetchedResultsController:frc
                            dequeueReusableCellBlock:builder.dequeueReusableCellBlock
                                  configureCellBlock:builder.configureCellBlock]) {
    _modelOfClass = builder.modelOfClass;
  }
  return self;
}

@end
