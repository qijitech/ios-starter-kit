//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJModel.h"

@interface QJUserToken : QJModel <NSCoding>

@property(nonatomic, copy) NSString *openId;
@property(nonatomic, copy) NSNumber *userId;
@property(nonatomic) BOOL isBind;
@property(nonatomic) NSUInteger platform;

@end