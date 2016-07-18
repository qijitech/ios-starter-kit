//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJModel.h"

@interface QJImage : QJModel

@property(nonatomic, copy) NSString *url;

- (NSURL *)toURL:(NSInteger)width height:(NSInteger)height;

@end