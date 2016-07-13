//
// Created by Hammer on 3/24/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKAbstractTableViewController.h"

@class SKHTTPSessionManager;

@interface SKTableViewController : SKAbstractTableViewController

/**
 The items managed by this data source.
 */
@property (copy, nonatomic, readonly) NSMutableArray *items;

@property (copy, nonatomic, readonly) NSArray *localItems;

@property(nonatomic, strong, readonly) SKHTTPSessionManager *httpSessionManager;

- (void)addLocalItems:(NSArray *)localItems;

@end