//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <TGRDataSource_qijitech/TGRDataSource.h>

@class SKFetchedResultsDataSource;

@interface SKFetchedResultsDataSourceBuilder : NSObject

@property(nonatomic, strong) Class modelOfClass;
@property(nonatomic, copy) NSString *entityName;
@property(nonatomic, copy) NSPredicate *predicate;
@property(nonatomic, copy) TGRDataSourceCellBlock configureCellBlock;
@property(nonatomic, copy) TGRDataSourceDequeueReusableCellBlock dequeueReusableCellBlock;

- (SKFetchedResultsDataSource *)build;

@end