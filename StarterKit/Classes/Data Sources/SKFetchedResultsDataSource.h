//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <TGRDataSource_qijitech/TGRFetchedResultsDataSource.h>

@class SKFetchedResultsDataSourceBuilder;

typedef void (^SKFetchedResultsDataSourceBuilderBlock)(SKFetchedResultsDataSourceBuilder *builder);

@interface SKFetchedResultsDataSource : TGRFetchedResultsDataSource

+ (instancetype)createWithBuilder:(SKFetchedResultsDataSourceBuilderBlock)block;
- (instancetype)initWithBuilder:(SKFetchedResultsDataSourceBuilder *)builder;

@end