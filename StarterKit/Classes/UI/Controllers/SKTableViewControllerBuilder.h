//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKTableViewController;
@class SKPaginator;

@interface SKTableViewControllerBuilder : NSObject

@property(nonatomic, copy) NSString *cellIdentifier;
@property(nonatomic, copy) NSString *entityName;
@property(nonatomic, strong) Class modelOfClass;
@property(nonatomic, strong) Class cellClass;

@property(nonatomic, strong) SKPaginator *paginator;

- (SKTableViewController *)build;

@end