//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKAbstractTableViewController.h"

@class SKAbstractTableViewController;
@class SKPaginator;

@interface SKTableViewControllerBuilder : NSObject

// required
@property(nonatomic, strong) NSArray *cellMetadata;
@property(nonatomic, strong) AnyPromise *(^paginateBlock)(NSDictionary *parameters);

// for fetched property
@property(nonatomic, strong) Class modelOfClass;
@property(nonatomic, copy) NSString *entityName;
@property(nonatomic, strong) NSPredicate *predicate;
@property(nonatomic, strong) NSArray<NSDictionary *> *sortDescriptors;

// optional
@property(nonatomic, strong) SKPaginator *paginator;

// for PaginatorContract
@property(nonatomic, strong) Class paginatorModelOfClass;
@property(nonatomic, copy) NSString *resultKeyValue;
@property(nonatomic, copy) NSString *subResultKeyValue;

// empty settings
@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, strong) UIFont *titleFont;
@property(nonatomic, strong) UIColor *subtitleColor;
@property(nonatomic, strong) UIFont *subtitleFont;

// for refresh
@property(nonatomic, assign) BOOL canRefresh;
@property(nonatomic, assign) BOOL canLoadMore;

@end
