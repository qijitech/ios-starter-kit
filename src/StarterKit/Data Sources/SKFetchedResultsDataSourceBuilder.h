//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <TGRDataSource/TGRDataSource.h>

@class SKFetchedResultsDataSource;

@interface SKFetchedResultsDataSourceBuilder : NSObject

@property(nonatomic, strong) Class modelOfClass;
@property(nonatomic, copy) NSString *entityName;
@property(nonatomic, copy) NSString *reuseIdentifier;
@property(nonatomic, assign) TGRDataSourceCellBlock configureCellBlock;
- (SKFetchedResultsDataSource *)build;

@end