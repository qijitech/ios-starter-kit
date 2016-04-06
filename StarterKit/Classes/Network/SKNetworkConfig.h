//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SKNetworkConfig : NSObject

@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, assign) NSUInteger perPage;
@property (nonatomic, copy) NSString *accept;
@property (nonatomic, copy) NSString *paramPageSize;
@property (nonatomic, copy) NSString *paramMaxId;
@property (nonatomic, copy) NSString *paramSinceId;
@property (nonatomic, copy) NSString *paramPage;

+ (SKNetworkConfig *)sharedInstance;

@end