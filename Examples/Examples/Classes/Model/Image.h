//
// Created by Hammer on 1/22/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "BaseModel.h"


@interface Image : BaseModel

@property(nonatomic, copy) NSString *type;
@property(nonatomic, strong) NSURL *url;

@end