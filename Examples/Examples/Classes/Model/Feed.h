//
// Created by Hammer on 1/22/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "BaseModel.h"

@class User;

@interface Feed : BaseModel

@property(nonatomic, copy) NSString *content;
@property(nonatomic, strong) NSNumber *shareTimes;
@property(nonatomic, strong) NSNumber *browseTimes;
@property(nonatomic, strong) NSNumber *commentTimes;
@property(nonatomic, strong) NSNumber *createdAt;

@property(nonatomic, strong) User *user;

@property(nonatomic, strong) NSArray *images;


@end