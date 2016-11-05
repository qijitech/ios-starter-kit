//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKPaginator.h"

@interface SKPagedPaginator : SKPaginator
@property(nonatomic, assign, readonly) NSUInteger firstPage;
@property(nonatomic, assign, readonly) NSUInteger nextPage;

@property(nonatomic, strong) Class resultClass;
@end