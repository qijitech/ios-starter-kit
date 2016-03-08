//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TGRDataSource_qijitech/TGRDataSource.h>
#import "SKTableViewController.h"

@class SKTableViewController;
@class SKPaginator;

@interface SKTableViewControllerBuilder : NSObject

// required
@property(nonatomic, copy) NSString *entityName;
@property(nonatomic, strong) Class modelOfClass;
@property (nonatomic, strong) NSArray *cellMetadata;
@property(nonatomic, strong) AnyPromise *(^paginateBlock)(NSDictionary *parameters);

// optional
@property(nonatomic, strong) SKPaginator *paginator;
@property(nonatomic, copy) NSString *cellReuseIdentifier;
@property(nonatomic, copy) TGRDataSourceDequeueReusableCellBlock dequeueReusableCellBlock;
@property(nonatomic, copy) TGRDataSourceCellBlock configureCellBlock;
@property(nonatomic, copy) NSPredicate *predicate;


@end