//
// Created by Hammer on 3/24/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKAbstractTableViewController.h"
#import "SKArrayDataSource.h"

@class SKHTTPSessionManager;

@interface SKTableViewController : SKAbstractTableViewController

@property(nonatomic, strong, readonly) SKHTTPSessionManager *httpSessionManager;

/**
 The data source used by this view controller.
 */
@property(strong, nonatomic) SKArrayDataSource *dataSource;

@end