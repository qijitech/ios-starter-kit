//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <TGRDataSource/TGRFetchedResultsDataSource.h>

@class SKFetchedResultsDataSourceBuilder;

typedef void (^SKFetchedResultsDataSourceBuilderBlock)(SKFetchedResultsDataSourceBuilder *builder);

@interface SKFetchedResultsDataSource : TGRFetchedResultsDataSource

+ (instancetype)createWithBuilder:(SKFetchedResultsDataSourceBuilder *)block;
- (instancetype)initWithBuilder:(SKFetchedResultsDataSourceBuilder *)builder;

@end