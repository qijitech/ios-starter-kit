//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <OvercoatCoreData/OVCManagedHTTPSessionManager.h>
#import <OvercoatPromiseKit/OVCHTTPSessionManager+PromiseKit.h>

@interface SKManagedHTTPSessionManager : OVCManagedHTTPSessionManager

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end