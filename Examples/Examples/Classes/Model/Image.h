//
// Created by Hammer on 1/22/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "BaseModel.h"


@interface Image : BaseModel

@property(nonatomic, strong) NSURL *url;
@property(nonatomic, assign) NSUInteger width;
@property(nonatomic, assign) NSUInteger height;

@end