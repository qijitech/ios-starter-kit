//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TGRDataSource_qijitech/TGRDataSource.h>
#import "SKAbstractTableViewController.h"

@class SKAbstractTableViewController;
@class SKPaginator;

@interface SKTableViewControllerBuilder : NSObject

// required
@property(nonatomic, copy) NSString *entityName;
@property(nonatomic, strong) Class modelOfClass;
@property(nonatomic, strong) NSArray *cellMetadata;
@property(nonatomic, strong) AnyPromise *(^paginateBlock)(NSDictionary *parameters);

// optional
@property(nonatomic, strong) SKPaginator *paginator;
@property(nonatomic, copy) NSString *cellReuseIdentifier;
@property(nonatomic, copy) TGRDataSourceDequeueReusableCellBlock dequeueReusableCellBlock;
@property(nonatomic, copy) TGRDataSourceCellBlock configureCellBlock;
@property(nonatomic, copy) NSPredicate *predicate;

// empty settings
@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, strong) UIFont *titleFont;
@property(nonatomic, strong) UIColor *subtitleColor;
@property(nonatomic, strong) UIFont *subtitleFont;

// for refresh
@property(nonatomic, assign) BOOL canRefresh;
@property(nonatomic, assign) BOOL canLoadMore;


@end