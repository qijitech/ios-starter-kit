//
// Created by Hammer on 3/24/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <TGRDataSource_qijitech/TGRDataSource.h>

@class SKArrayDataSource;

@interface SKArrayDataSourceBuilder : NSObject

@property(nonatomic, strong) Class modelOfClass;
@property(nonatomic, copy) NSString *entityName;
@property(nonatomic, copy) TGRDataSourceCellBlock configureCellBlock;
@property(nonatomic, copy) TGRDataSourceDequeueReusableCellBlock dequeueReusableCellBlock;

- (SKArrayDataSource *)build;

@end