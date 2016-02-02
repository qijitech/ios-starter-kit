//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SKNetworkConfig : NSObject

@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, assign) NSUInteger perPage;
@property (nonatomic, copy) NSString *accept;

+ (SKNetworkConfig *)sharedInstance;

@end